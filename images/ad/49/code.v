module top_module(
    input wire clk,
    input wire reset_n,
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] sum,
    output reg carry  // Changed to reg to allow assignment in always block
);reg [8:0] temp_sum;
    
    always @ (posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            temp_sum <= 0;
            carry <= 0;
        end else begin
            temp_sum <= a + b;
            carry <= temp_sum[8];
        end
    end
    
    assign sum = temp_sum[7:0];

endmodule