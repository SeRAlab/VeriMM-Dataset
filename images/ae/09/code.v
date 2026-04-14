module top_module(
    input [3:0] B,
    input clk,                // Added clock input
    output reg [3:0] R,
    output reg [1:0] LZ
);reg [1:0] lz_temp;
reg [3:0] r_temp;

// Pipeline stage 1: Reverse the bits
always @(*) begin
    r_temp[0] = B[3];
    r_temp[1] = B[2];
    r_temp[2] = B[1];
    r_temp[3] = B[0];
end

// Pipeline stage 2: Count the leading zeros
always @(*) begin
    lz_temp = 2'b00;
    if (r_temp[3] == 1) begin
        lz_temp = 2'b00;
    end else if (r_temp[2] == 1) begin
        lz_temp = 2'b01;
    end else if (r_temp[1] == 1) begin
        lz_temp = 2'b10;
    end else if (r_temp[0] == 1) begin
        lz_temp = 2'b11;
    end
end

// Pipeline stage 3: Output the results
always @(posedge clk) begin
    R <= r_temp;
    LZ <= lz_temp;
end

endmodule