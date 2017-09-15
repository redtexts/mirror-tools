BEGIN {conf=1;}
$0 !~ /\w+:\t+.*/ { conf=0; }
conf == 0 && confed == 0 {
        print "---";
		# gsub(/'/, "\\'", md["Title"])
		print "title: |\n\t" md["Title"] ""
        print "author: " md["Author"];
        print "date: " md["Date"];
		# gsub(/'/, "\\'", md["Description"])
        print "description: |\n\t" md["Description"] "";
        print "rights: Public Domain";
        print "language: en-US";
		if (css)
			print "stylesheet: ./files/" css;
        print "---";
        confed = 1;
}

/\w+:\t+.*/ { 
        data=$2; 
        for(i=3;i<=NF;i++)
                data=data" "$i;
        md[gensub(/:$/,"","g",$1)]=data;
        conf=1;
}

$0 !~ /{{.*}}/ &&
$0 !~ /\w+:\t+.*/ {  print }
