module top_module(
    
    
    input wire MS,           
    input wire [7:0] D_0,    
    input wire [7:0] D_1,    
    
    
    output reg [7:0] D_out   
    );always @*
        begin
            case(MS)
                1'b0: D_out = D_0;
                1'b1: D_out = D_1;
                default : D_out = D_0;
            endcase
        end

endmodule