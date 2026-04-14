module top_module(
    clk,
    rst,
    en,
    count
);input clk;
    input rst;
    input en;
    output [3:0] count;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    reg [3:0] count_reg;

    always @(posedge clk) begin
        if (rst == 1) begin
            count_reg <= 0;
        end else if (en == 1) begin
            count_reg <= count_reg + 1;
        end
    end

    assign count = count_reg;

endmodule