module interrupt_controller(  
    input [2:0] int_req,  
    input clk,  
    input reset,  
    output reg [2:0] int_ack  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            int_ack <= 3'b000;  
        end else begin  
            case (int_req)  
                3'b001: int_ack <= 3'b001;  
                3'b010: int_ack <= 3'b010;  
                3'b100: int_ack <= 3'b100;  
                default: int_ack <= 3'b000;  
            endcase  
        end  
    end  
endmodule