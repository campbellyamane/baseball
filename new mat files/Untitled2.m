legends_players={'Jackie Robinson','Derek Jeter','Ted Williams',...
    'Babe Ruth','Willie Mays','Lou Gehrig',...
    'Mike Schmidt','Yogi Berra','Walter Johnson'};

legends_hits=[.262,.275,.271,.271,.263,.282,.222,.257,.217];
legends_singles=[.262,.275,.271,.271,.263,.282,.222,.257,.217];
legends_doubles=[.180,.157,.198,.176,.159,.196,.183,.149,.172];
legends_triples=[.180,.157,.198,.176,.159,.196,.183,.149,.172];
legends_homers=[.180,.157,.198,.176,.159,.196,.183,.149,.172];
legends_walks=[.159,.112,.213,.209,.129,.172,.170,.097,.077];
legends_outs=1-legends_hits-legends_walks;
contents = dir('*.jpg');
names={contents.name};
for x=1:length(names)
    identity = double(imread(names{:,x}));
    legends_faces{x} = identity;
end
for x=1:length(legends_players)
    legends(x).name = legends_players(x);
    legends(x).hits = legends_hits(x);
    legends(x).singles = legends_singles(x);
    legends(x).doubles = legends_doubles(x) + legends(x).singles;
    legends(x).triples = legends_triples(x) + legends(x).doubles;
    legends(x).homers = legends_homers(x) + legends(x).triples;
    legends(x).walks = legends_walks(x) + legends_hits(x);
    legends(x).outs = legends_outs(x); 
    legends(x).faces = legends_faces(x);
end
save('legends_stats.mat','legends');