#!/usr/bin/ruby
def start
	puts "------------BATAILLE NAVALE------------"
	puts "G|M|P x y"
	puts "grands0 bateau(4x3)"
	puts "moyens0 (3x2)"
	puts "petits0 (2x1)"
	puts "Sur une zone de 10x10."
	puts "Tapez rand pour avoir un placement aleatoire"
	joueur = zero
	grands0 = 0
	moyens0 = 0
	petits0 = 0
	#poser les bateaux
	while (grands0 + moyens0 + petits0 < 6)
		gets
		if ($_ =~ /^[gmp] [0-9][ ,*x]?[0-9]$/i )
			#puts "Coordonnee acceptable"
			if ( ( t1 = verifinserer(joueur,$_[0],Integer($_[2]),Integer($_[4])) ) && (t2 = bateaux(grands0,moyens0,petits0,$_[0])) )
				grands0 = t2[0]
				moyens0 = t2[1]
				petits0 = t2[2]
				joueur = inserer(joueur,$_[0],Integer($_[2]),Integer($_[4]),t1[0],t1[1])
				puts "Position inseree."
				lire(joueur)
			end
		elsif($_ =~ /rand/)
			joueur = iaposer
			lire(joueur)
			grands0=1
			moyens0=2
			petits0=3
			break
		else
			puts "Impossible de comprendre la commande."
		end
	end
	#Choix IA
	puts "Intelligence de l'ordinateur:\n[F]Facile\n[M]Moyen\n[D]Difficile"
	gets while(!($_ =~ /[FMD]/))
	puts "Vous avez choisi #{$_}"
	ia = iaposer
	jouer(joueur,ia,$_)
end
def jouer(joueur,ia,difficulte)
	diff = difficulte
	adv_joueur = zero
	adv_ia=zero
	lire(joueur,adv_joueur)
	tour =1
	j1=j2=30
	puts "Precisez une coordonne x y"
	while(j1>0 && j2>0)
		if(tour%2==1)
			$_ = ""
			gets while !($_ =~ /^[0-9][ ,]{1}[0-9]$/ )
			tab = attaque(adv_joueur,ia,Integer($_[0]),Integer($_[2]),j2)
			adv_joueur = tab[0]
			ia = tab[1]
			j2 = tab[2]
			puts "Score : #{j1} a #{j2}"
			lire(joueur,adv_joueur)
		else
			if( diff =~ /F/ )
				x = rand(9)
				y = rand(9)
				while (adv_ia[x][y]!=0)
					x = rand(9)
					y = rand(9)				
				end
				puts "CPU joue en (#{x},#{y})"
				tab = attaque(adv_ia,joueur,x,y,j1)
				adv_ia = tab[0]
				joueur = tab[1]
				j1 = tab[2]
			elsif (diff =~ /M/ )
				tab1 = moyen(adv_ia,joueur,j1)
				adv_ia = tab[0]
				joueur = tab[1]
				j1 = tab[2]
			elsif (diff =~ /D/ )
				x = rand(9)
				y = rand(9)
				while (joueur[x][y]==0)
					x = rand(9)
					y = rand(9)				
				end
				puts "CPU joue en (#{x},#{y})"
				tab = attaque(adv_ia,joueur,x,y,j1)
				adv_ia = tab[0]
				joueur = tab[1]
				j1 = tab[2]
			else 
				puts "ERREUR"
			end
		end
		tour+=1
	end
	if(j1 == 0)
		puts "Vous avez perdu."
	else 
		puts "Vous avez gagne."
	end
end
def moyen(tab,adv,p)
	c = false
	i=0
	j=0
	while i < tab.length
		
		while j < tab[i].length	
			if(tab[i][j]==2)
				c = true
				break
			end
	    	j += 1
	    end
	    if(c==true)
	    	break
	    end
	    i+=1
	end
	x = rand(9)
	y = rand(9)
	if(c == true)
		while(
				tab[x][y]!=1 && 
				(
					tab[x][y+1]==2 ||			
					tab[x][y-1]==2 ||
					tab[x+1][y]==2 || 
					tab[x+1][y-1]==2 || 
					tab[x+1][y+1]==2 || 
					tab[x-1][y]==2 || 
					tab[x-1][y+1]==2|| 
					tab[x-1][y-1]==2
				)
			)
			x = rand(9)
			y = rand(9)
		end
	end
	return attaque(tab,adv,x,y,p)
end
def lire(tab,tab_adv=nil)
	i = 0
	if(tab_adv!=nil)
		puts "	JOUEUR 			IA"
	end
	print "  "
	while i < tab.length
		print "#{i} "
		i +=1
	end
	if(tab_adv!=nil)
		print "	  "
		i = 0
		while i < tab.length
			print "#{i} "
			i +=1
		end 
	end
	puts ""
	i = 0
	while i < tab.length
		j = 0
		print "#{i} "
		while j < tab[i].length	
	    	if(tab[i][j]==1)
	    		print "G "
	    	elsif(tab[i][j]==2)
	    		print "M "
	    	elsif(tab[i][j]==3)
	    		print "P "
		    elsif(tab[i][j]==4)
		    	print "X "
	    	else 
	    		print ". "
	    	end
	    	j += 1
		end	
		if(tab_adv!=nil)
			print "	"
			j = 0
			print "#{i} "
			while j < tab[i].length	
	    		if(tab_adv[i][j]==2)
	    			print "X "
	    		elsif(tab_adv[i][j]==1)
	    			print "O "
	    		else
	    			print ". "
	    		end
	    		j += 1
			end	
		end
		puts ""
		i += 1
	end	
end
#on regarde si on peut placer un bateau
def verifinserer(tableau,bateau,x,y,joueur=nil)
	if( x>=0 && y >= 0 && x <10 && y < 10 )
		a = 0
		b = 0
		#on definit la taille du bateau
		#et on regarde si on a assez de place par rapport a la zone
		#de jeu
		if((bateau=="g" || bateau=="G") && (10-x>=4 && 10-y>=3))
			#puts "GRAND #{x} #{y}"
			a = 3
			b = 2
		elsif((bateau=="m" || bateau=="M") && (10-x>=3 && 10-y>=2))
			#puts "MOYEN #{x} #{y}"
			a = 2
			b = 1
		elsif((bateau=="p" || bateau=="P") && (10-x>=2 && 10-y>=1))
			#puts "PETIT #{x} #{y}"
			a = 1
			b = 0
		else
			if(joueur == nil)
				puts "Pas assez de place pour poser le bateau, recommencez ailleurs."
			end
			return nil
		end
		#on verifie si on a assez de place pour mettre le bateau 
		#parmis ceux qui sont deja posés
		i = y
		while i <= y+b
			j = x
			while j <= x+a
				if(tableau[i][j]!=0)
					if(joueur ==nil)
						puts "Impossible de placer un bateau"
					end
					return nil
				end
				j += 1
			end
			i += 1
		end
		#Si on peut poser le bateau, on renvoit sa taille
		return [a,b]
	else
		if(joueur== nil)
			puts "La place est hors de la zone de jeu"
		end
		return nil
	end
end
def inserer(tableau,bateau,x,y,a,b)
	c = ""
	case a
	when 3
		c = 1
	when 2
		c = 2
	when 1
		c = 3
	end
	i = y
	while i <= y+b
		j = x
		while j <= x+a
			tableau[i][j]=c
			j += 1
		end
		i += 1
	end
	return tableau
end
def iaposer
	tab = zero
	#grands
	tab = inserer(tab,3,rand(0-7),rand(0-8),3,2)
	#moyens
	2.times do
		t1 = nil
		while t1 == nil
			x = rand(0-7)
			y = rand(0-8)
			t1 = verifinserer(tab,"m",x,y,"ia") 
		end
		tab = inserer(tab,2,x,y,t1[0],t1[1])	
	end
	#petits
	3.times do
		t1 = nil
		while t1 == nil
			x = rand(0-8)
			y = rand(9)
			t1 = verifinserer(tab,"p",x,y,"ia") 
		end
		tab = inserer(tab,1,x,y,t1[0],t1[1])
	end
	return tab
end
def zero
	tab = Array.new(10)
	i=0
	while i < tab.length
		tab[i]=Array.new(10)
		j = 0
		while j < tab.length
			tab[i][j]=0
			j+=1
		end
		i+=1
	end
	return tab
end
def bateaux(g,m,p,type,joueur=nil)
	if(type =~ /[Gg]/ && g <1 )
		g+=1
	elsif(type =~ /[Mm]/ && m < 2)
		m+=1
	elsif(type =~ /[Pp]/ && p < 3) 
		p+=1
	else 
		if(joueur == nil)
			puts "Impossible de mettre plus ce type de bateaux."
		end
		return nil
	end
	return [g,m,p]
end
def attaque(tab,adv,x,y,p)
	if(adv[x][y]!=0)
		tab[x][y]=2
		adv[x][y]=4
		p-=1
	elsif (tab[x][y]!=2)
		tab[x][y]=1
	end
	return [tab,adv,p]
end
#Main
start