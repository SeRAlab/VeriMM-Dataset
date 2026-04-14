module top_module(
    input wire [2:0] operation,
    input wire [31:0] left, right,
    output reg [31:0] result
);always @* begin
        result = 32'b0;
        case(operation)
            3'd0: begin
                
                
                result = left >> right[4:0];
            end
            3'd1: begin
                
                result = $signed(left) >>> right[4:0];
            end
            3'd2: begin
                
                result = $signed(left) < $signed(right);
            end
            3'd3: begin
                
                result = left < right;
            end
        endcase
    end

    
    reg [31:0] result2;
    reg [31:0] __temp;
    
    always @* begin
        result2 = 32'b0;
        __temp = 32'b0;
        case(operation)
            3'd0: begin
                
                
                result2 = left >> right[4:0];
            end
            3'd1: begin
                

                
                
                
                __temp = {32{left[31]}} & ~ ((33'd1 << (6'd32 - right[4:0])) - 33'd1);
                result2 = __temp | (left >> right[4:0]);
            end
            3'd2: begin
                
                case({left[31], right[31]})
                    2'b00: result2 = left < right; 
                    2'b01: result2 = 32'd0; 
                    2'b10: result2 = 32'd1; 
                    2'b11: result2 = -left > -right; 
                endcase
            end
            3'd3: begin
                
                result2 = left < right;
            end
        endcase
    end

endmodule