giants_players={'Denard Span','Joe Panik','Matt Duffy',...
    'Buster Posey','Brandon Belt','Hunter Pence'...
    'Brandon Crawford','Angel Pagan','Madison Bumgarner'};

giants_hits=[.219,.227,.224,.236,.226,.251,.225,.248,.143];
giants_singles=[.783,.634,.727,.634,.651,.660,.610,.758,.500];
giants_doubles=[.152,.171,.182,.244,.186,.170,.220,.152,.250];
giants_triples=[.043,.073,.045,.000,.070,.021,.024,.030,.000];
giants_homers=[.022,.122,.045,.122,.093,.149,.146,.061,.250];
giants_walks=[.148,.105,.087,.109,.195,.144,.121,.098,.071];
giants_outs=1-giants_hits-giants_walks;
for x=1:length(giants_players)
    giants(x).name = giants_players(x);
    giants(x).hits = giants_hits(x);
    giants(x).singles = giants_singles(x);
    giants(x).doubles = giants_doubles(x) + giants(x).singles;
    giants(x).triples = giants_triples(x) + giants(x).doubles;
    giants(x).homers = giants_homers(x) + giants(x).triples;
    giants(x).walks = giants_walks(x) + giants_hits(x);
    giants(x).outs = giants_outs(x);   
end
save('giants_stats.mat','giants');