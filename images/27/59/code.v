module robot_navigation (  
    input clk,  
    input reset,  
    input [1:0] command,  
    output reg [1:0] direction  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            direction <= 2'b00; // Initial direction: North  
        else begin  
            case (command)  
                2'b00: direction <= 2'b00; // North  
                2'b01: direction <= 2'b01; // East  
                2'b10: direction <= 2'b10; // South  
                2'b11: direction <= 2'b11; // West  
                default: direction <= direction; // Maintain current direction  
            endcase  
        end  
    end  
endmodule