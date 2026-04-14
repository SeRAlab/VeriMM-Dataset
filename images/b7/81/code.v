module top_module(
    input  wire   clk_brd,rst,
    output wire   clk
);reg [27:0] counter;
always @(posedge clk_brd or negedge rst)
    begin
        if (!rst)
            begin
                counter <= 28'b00;
            end
        else
            begin
                counter <= counter + 28'b01;
            end
    end
assign clk = counter[25];
endmodule