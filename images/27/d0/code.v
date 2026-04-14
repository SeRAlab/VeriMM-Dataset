module gradient_descent (
    input clk,
    input rst,
    input [31:0] weight,
    input [31:0] learning_rate,
    input [31:0] gradient,
    output reg [31:0] updated_weight
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_weight <= 32'd0;
        end else begin
            updated_weight <= weight - (learning_rate * gradient);
        end
    end

endmodule