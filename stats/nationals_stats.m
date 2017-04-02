nationals_players={'Michael Taylor','Jason Werth','Bryce Harper',...
    'Daniel Murphy','Ryan Zimmerman','Anthony Rendon',...
    'Wilson Ramos','Danny Espinosa','Stephen Strasburg'};

nationals_hits = [.180,.2,.183,.359,.208,.227,.317,.174,.167];
nationals_singles = [.65,.53,.437,.633,.577,.738,.684,.778,1];
nationals_doubles = [.175,.27,.219,.233,.272,.214,.211,.111,0];
nationals_triples = [0,0,0,.033,0,0,0,0,0];
nationals_homers = [.175,.2,.344,.101,.151,.048,.105,.111,0];
nationals_walks = [.055,.08,.263,.054,.089,.114,.05,.09,0];
nationals_outs=1-nationals_hits-nationals_walks;
for x=1:length(nationals_players)
    nationals(x).name = nationals_players(x);
    nationals(x).hits = nationals_hits(x);
    nationals(x).singles = nationals_singles(x);
    nationals(x).doubles = nationals_doubles(x) + nationals(x).singles;
    nationals(x).triples = nationals_triples(x) + nationals(x).doubles;
    nationals(x).homers = nationals_homers(x) + nationals(x).triples;
    nationals(x).walks = nationals_walks(x) + nationals_hits(x);
    nationals(x).outs = nationals_outs(x);   
end
save('nationals_stats.mat','nationals');
