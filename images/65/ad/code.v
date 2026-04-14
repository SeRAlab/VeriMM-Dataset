module top_module(
    input [3:0] A,
    input clk,  // Added clk input
    output reg [15:0] Y
);reg [15:0] Y1, Y2, Y3, Y4;

always @ (posedge clk) begin
    Y1 <= 16'b1111111111111111; // Initialize Y1 to all ones
    Y1[A] <= 1'b0; // Set the Y1 output corresponding to input A to 0
end

assign Y = Y4;

always @ (posedge clk) begin
    Y2 <= Y1;
end

always @ (posedge clk) begin
    Y3 <= Y2;
end

always @ (posedge clk) begin
    Y4 <= Y3;
end

always @ (posedge clk) begin
    if (A == 4'b0000) begin
        Y1 <= 16'b1111111111111110;
    end else if (A == 4'b0001) begin
        Y1 <= 16'b1111111111111101;
    end else if (A == 4'b0010) begin
        Y1 <= 16'b1111111111111011;
    end else if (A == 4'b0011) begin
        Y1 <= 16'b1111111111110111;
    end else if (A == 4'b0100) begin
        Y1 <= 16'b1111111111101111;
    end else if (A == 4'b0101) begin
        Y1 <= 16'b1111111111011111;
    end else if (A == 4'b0110) begin
        Y1 <= 16'b1111111110111111;
    end else if (A == 4'b0111) begin
        Y1 <= 16'b1111111101111111;
    end else if (A == 4'b1000) begin
        Y1 <= 16'b1111111011111111;
    end else if (A == 4'b1001) begin
        Y1 <= 16'b1111110111111111;
    end else if (A == 4'b1010) begin
        Y1 <= 16'b1111101111111111;
    end else if (A == 4'b1011) begin
        Y1 <= 16'b1111011111111111;
    end else if (A == 4'b1100) begin
        Y1 <= 16'b1110111111111111;
    end else if (A == 4'b1101) begin
        Y1 <= 16'b1101111111111111;
    end else if (A == 4'b1110) begin
        Y1 <= 16'b1011111111111111;
    end else if (A == 4'b1111) begin
        Y1 <= 16'b0111111111111111;
    end else begin
        Y1 <= 16'b1111111111111111;
    end
end

endmodule