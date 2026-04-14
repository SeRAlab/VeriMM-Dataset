module top_module(Branch, instruction, Zero, read_data1, PCSrc);input Branch, Zero;
    input [5:0] instruction;
    input [31:0] read_data1;
    output reg PCSrc;

    
    always @(*) begin
        if (Branch) begin
            case(instruction)
                6'b000100:          
                begin
                    PCSrc = Zero;
                end
                6'b000101:          
                begin
                    PCSrc = ~Zero;
                end
                6'b000111:          
                begin
                    if(read_data1 > 0) 
                        PCSrc = 1;
                    else
                        PCSrc = 0;
                end
                6'b000110:          
                begin
                    if(read_data1 <= 0)
                        PCSrc = 1;
                    else
                        PCSrc = 0;
                end
                
                default: PCSrc = 0;
            endcase
        end
    end
endmodule