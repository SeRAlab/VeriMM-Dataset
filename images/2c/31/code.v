module pipeline_processor(clk, rst, opcode, A, B, result, valid);  
    input clk;  
    input rst;  
    input [1:0] opcode;  
    input [7:0] A;  
    input [7:0] B;  
    output reg [7:0] result;  
    output reg valid;  

    reg [7:0] intermediate;  
    reg [1:0] current_opcode;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            intermediate <= 8'b0;  
            current_opcode <= 2'b00;  
            valid <= 1'b0;  
        end else begin  
            current_opcode <= opcode;  
            case (current_opcode)  
                2'b00: intermediate <= A + B;  
                2'b01: intermediate <= A - B;  
                2'b10: intermediate <= 8'b0;  
                default: intermediate <= 8'b0;  
            endcase  
            result <= intermediate;  
            valid <= 1'b1;  
        end  
    end  
endmodule