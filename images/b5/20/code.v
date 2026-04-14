module top_module(input [3:0] a, input [3:0] b, output reg [3:0] sum);// Changed sum to output reg
    wire [4:0] temp_sum;
    
    assign temp_sum = a + b;
    
    always @(*) begin
        if (temp_sum > 15) begin
            sum = temp_sum - 16; // sum can now be assigned
        end
        else begin
            sum = temp_sum; // sum can now be assigned
        end
    end
endmodule