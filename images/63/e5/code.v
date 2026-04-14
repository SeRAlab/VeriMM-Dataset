module top_module(
    input [7:0] I,
    input clk,          // Added clk input
    output reg EN,
    output reg [2:0] OUT // Changed the size to [2:0] to use 3 bits correctly
);reg [7:0] I_reg;
reg [2:0] OUT_reg; // Changed the size to [2:0] to align with OUT output

always @(posedge clk) begin
    I_reg <= I;
    OUT_reg <= OUT_reg;
end

always @(posedge clk) begin
    if (I_reg[7]) begin
        OUT_reg <= 3'b111;
    end else if (I_reg[6]) begin
        OUT_reg <= 3'b110;
    end else if (I_reg[5]) begin
        OUT_reg <= 3'b101;
    end else if (I_reg[4]) begin
        OUT_reg <= 3'b100;
    end else if (I_reg[3]) begin
        OUT_reg <= 3'b011;
    end else if (I_reg[2]) begin
        OUT_reg <= 3'b010;
    end else if (I_reg[1]) begin
        OUT_reg <= 3'b001;
    end else if (I_reg[0]) begin
        OUT_reg <= 3'b000;
    end
end

always @(posedge clk) begin
    if (I_reg != 8'b00000000) begin
        EN <= 1'b1;
    end else begin
        EN <= 1'b0;
    end
end

assign OUT = OUT_reg;

endmodule