module pcie_controller (  
    input wire clk,  
    input wire reset,  
    input wire req,  
    output reg ack  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            ack <= 0;  
        end else if (req) begin  
            ack <= 1;  
        end else begin  
            ack <= 0;  
        end  
    end  
endmodule