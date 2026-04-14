module top_module(
    input iA,
    input iB,
    input iC,
    output reg oS,
    output reg oC
    );always@(*)
    begin
    oC=(iA&iB)|(iA&iC)|(iB&iC);
    if(iC)
    oS=!(iA^iB);
    else
    oS=(iA^iB);
    end
endmodule