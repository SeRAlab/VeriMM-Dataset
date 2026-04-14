module top_module(
    input     wire     [1:0]       IN,
    input     wire                 CLK, RST,
    output    wire     [1:0]       OUT,
    output    reg                 Not_Equal_3
);assign OUT = IN + 2'b01;
always @(posedge  CLK or negedge RST)
    begin
        if(!RST)
            begin
                Not_Equal_3 <= 1'b0;
            end
        else
            begin
                Not_Equal_3 <= (IN != 2'd2);
            end
    end
endmodule