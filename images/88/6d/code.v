module counter_5bit_up(
    input clk, rst, load,
    input [4:0] load_value,
    output reg [4:0] q);

    always @(posedge clk) begin
        if (rst)
            q <= 5'b00000;
        else if (load)
            q <= load_value;
        else
            q <= q + 1;
    end
endmodule