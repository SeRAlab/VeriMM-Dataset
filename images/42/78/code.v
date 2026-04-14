module top_module(
    input clk,
    input [1:0] a,
    input [1:0] b,
    input cin,
    output reg [1:0] sum,
    output reg cout
);reg [2:0] temp_sum;

    always @(posedge clk) begin
        temp_sum <= {1'b0, a} + {1'b0, b} + {1'b0, cin};
        sum <= temp_sum[1:0]; // Assign sum as a reg
        cout <= temp_sum[2];   // Assign cout as a reg
    end

endmodule