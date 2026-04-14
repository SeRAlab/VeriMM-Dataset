module top_module(
    input clk,
    input rst,
    input [3:0] multiplicand,
    input [3:0] multiplier,
    output reg [7:0] product
);reg [3:0] A;
reg [4:0] S; // Increased S to 5 bits to hold the appended extra bit
reg [2:0] count;

always @(posedge clk) begin
    if (rst) begin
        product <= 8'b0;
        A <= 4'b0;
        S <= {multiplier, 1'b0}; // Initialize S with multiplier and an extra bit
        count <= 3'b0;
    end else begin
        if (count == 3'b0) begin
            if (S[1:0] == 2'b01) begin
                product <= product + {A, 4'b0}; // Ensure A is appropriately concatenated
            end else if (S[1:0] == 2'b10) begin
                product <= product + {~A + 1'b1, 4'b0}; // Properly handle the addition of two's complement
            end
            S <= {S[3:2], A[3], S[1:0]}; // Fix S assignment
            A <= 4'b0;
            count <= 3'b1;
        end else begin
            if (S[1:0] == 2'b01) begin
                A <= A + multiplicand;
            end else if (S[1:0] == 2'b10) begin
                A <= A - multiplicand;
            end
            S <= {S[3:2], A[3], S[1:0]}; // Fix S assignment
            count <= count + 1;
        end
    end
end

endmodule