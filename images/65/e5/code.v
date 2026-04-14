module top_module(
    input clk,              // Added clk input
    input [7:0] in,
    output reg [2:0] pos
);reg [7:0] in_reg;

always @(posedge clk) begin
    in_reg <= in;
end

always @(posedge clk) begin
    if (in_reg[7]) begin
        pos <= 3'b111;     // Changed to 3'b for 3-bit assignment
    end else if (in_reg[6]) begin
        pos <= 3'b110;     // Changed to 3'b for 3-bit assignment
    end else if (in_reg[5]) begin
        pos <= 3'b101;     // Changed to 3'b for 3-bit assignment
    end else if (in_reg[4]) begin
        pos <= 3'b100;     // Changed to 3'b for 3-bit assignment
    end else if (in_reg[3]) begin
        pos <= 3'b011;     // Changed to 3'b for 3-bit assignment
    end else if (in_reg[2]) begin
        pos <= 3'b010;     // Changed to 3'b for 3-bit assignment
    end else if (in_reg[1]) begin
        pos <= 3'b001;     // Changed to 3'b for 3-bit assignment
    end else if (in_reg[0]) begin
        pos <= 3'b000;     // Changed to 3'b for 3-bit assignment
    end else begin
        pos <= 3'bxxx;     // Default case to handle when all inputs are low
    end
end

endmodule