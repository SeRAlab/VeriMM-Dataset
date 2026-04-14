module top_module(
    input [3:0] A,
    input [3:0] B,
    input sel,
    input rst,
    input clk,     // Added clk input
    output reg [3:0] C   // Changed output to reg type to allow assignment in always block
);reg [3:0] sum;
    reg [3:0] xor_result; // Changed variable name to avoid conflict with keyword

    always @(*) begin
        if (sel == 1) begin
            xor_result = A ^ B; // Use xor_result instead of xor
            sum = 4'b0;
        end else begin
            sum = A + B;
            xor_result = 4'b0; // Use xor_result instead of xor
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            C <= 4'b0;
        end else begin
            if (sel == 1) begin
                C <= xor_result; // Use xor_result instead of xor
            end else begin
                C <= sum;
            end
        end
    end

endmodule