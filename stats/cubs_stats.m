cubs_players={'Dexter Fowler','Jason Heyward','Kris Bryant',...
    'Anthony Rizzo','Ben Zobrist','Jorge Soler',...
    'Addison Russell','David Ross','Jake Arrieta'};

cubs_hits=[.258,.194,.245,.195,.263,.172,.199,.2,.208];
cubs_singles=[.562,.813,.587,.432,.702,.65,.624,.624,.8];
cubs_doubles=[.292,.156,.217,.243,.17,.2,.188,.188,0];
cubs_triples=[.042,0,0,.027,0,0,.063,0,0];
cubs_homers=[.104,.031,.196,.298,.128,.15,.125,.188,.2];
cubs_walks=[.183,.139,.117,.189,.196,.129,.149,.2,.125];
cubs_outs=1-cubs_hits-cubs_walks;
for x=1:length(cubs_players)
    cubs(x).name = cubs_players(x);
    cubs(x).hits = cubs_hits(x);
    cubs(x).singles = cubs_singles(x);
    cubs(x).doubles = cubs_doubles(x) + cubs(x).singles;
    cubs(x).triples = cubs_triples(x) + cubs(x).doubles;
    cubs(x).homers = cubs_homers(x) + cubs(x).triples;
    cubs(x).walks = cubs_walks(x) + cubs_hits(x);
    cubs(x).outs = cubs_outs(x);   
end
save('cubs_stats.mat','cubs');