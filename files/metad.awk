BEGIN {conf=1;}
$0 !~ /\w+:\t+.*/ { conf=0; }
/\w+:\t+.*/ { 
        data=$2; 
        for(i=3;i<=NF;i++)
                data=data" "$i;
        md[gensub(/:$/,"","g",$1)]=data;
        conf=1;
}
