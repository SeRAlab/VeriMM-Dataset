module interrupt_controller(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] interrupt_req,  
    input wire global_enable,  
    input wire clear,  
    output reg [3:0] interrupt_flag  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            interrupt_flag <= 4'b0000;  
        end else if (clear) begin  
            interrupt_flag <= 4'b0000;  
        end else if (global_enable) begin  
            case (interrupt_req)  
                4'b0001: interrupt_flag <= 4'b0001;  
                4'b0010: interrupt_flag <= 4'b0010;  
                4'b0100: interrupt_flag <= 4'b0100;  
                4'b1000: interrupt_flag <= 4'b1000;  
                default: interrupt_flag <= 4'b0000;  
            endcase  
        end  
    end  

endmodule