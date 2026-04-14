module top_module(
    input [3:0] A,
    input LOAD,
    input CLK,
    input clk,
    input rst,
    input en,
    input up,
    output [3:0] q
);reg [3:0] shift_reg;
reg [3:0] count;

always @(posedge CLK) begin
    if (LOAD) begin
        shift_reg <= A;
    end else begin
        shift_reg <= {shift_reg[2:0], shift_reg[3]};
    end
    
    if (en) begin
        if (up) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end
end

assign q = shift_reg + count;

endmodule