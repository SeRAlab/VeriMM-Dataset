module top_module(
    input   clk,
    input   rst,
    output  Reset_S
    );reg    Qok, Qmeta;
    
    assign  Reset_S = ~Qok;
    
    always @(posedge clk, posedge rst)
        if(rst)
            Qmeta <= 1'b0;
        else
            Qmeta <= 1'b1;
    
    always @(posedge clk)
        Qok <= Qmeta;
endmodule