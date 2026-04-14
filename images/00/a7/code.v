module deadbeat_controller(  
    input clk,  
    input rst,  
    input [2:0] state,  
    output reg [1:0] control  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            control <= 2'b00;  
        end else begin  
            case (state)  
                3'b000: control <= 2'b00;  
                3'b001: control <= 2'b01;  
                3'b010: control <= 2'b10;  
                3'b011: control <= 2'b11;  
                3'b100: control <= 2'b01;  
                3'b101: control <= 2'b10;  
                3'b110: control <= 2'b11;  
                3'b111: control <= 2'b00;  
                default: control <= 2'b00;  
            endcase  
        end  
    end  
endmodule