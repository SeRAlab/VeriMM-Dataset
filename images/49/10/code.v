module top_module(
    input clk,                // Add clk input
    input [2:0] ABC,
    output reg [7:0] Y
);reg [2:0] A, B, C;
reg [7:0] Y_temp;

always @ (posedge clk) begin
    A <= ABC[0];
    B <= ABC[1];
    C <= ABC[2];
end

always @ (posedge clk) begin
    Y_temp <= 8'b00000000;
    if (A == 3'b000) Y_temp[0] <= 1;
    else if (A == 3'b001) Y_temp[1] <= 1;
    else if (A == 3'b010) Y_temp[2] <= 1;
    else if (A == 3'b011) Y_temp[3] <= 1;
    else if (A == 3'b100) Y_temp[4] <= 1;
    else if (A == 3'b101) Y_temp[5] <= 1;
    else if (A == 3'b110) Y_temp[6] <= 1;
    else if (A == 3'b111) Y_temp[7] <= 1;
end

always @ (posedge clk) begin
    Y <= Y_temp;
end

endmodule