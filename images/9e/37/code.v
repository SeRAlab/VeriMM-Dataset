module top_module(
    input clk,
    input [3:0] in,
    input [1:0] delay,
    output reg [3:0] out
);reg [3:0] delay_reg[0:3]; // Changed size to accommodate delays 1, 2, and 3
integer i;

always @(posedge clk) begin
    delay_reg[0] <= in;
    for (i = 1; i < 4; i = i + 1) begin // Updated loop range
        delay_reg[i] <= delay_reg[i-1];
    end
    
    case (delay)
        2'b00: out <= delay_reg[0]; // Use delay_reg[0] for 0 delay
        2'b01: out <= delay_reg[1]; // Use delay_reg[1] for 1 delay
        2'b10: out <= delay_reg[2]; // Use delay_reg[2] for 2 delays
        2'b11: out <= delay_reg[3]; // Use delay_reg[3] for 3 delays
    endcase
end

endmodule