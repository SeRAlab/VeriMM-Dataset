module dma_controller (  
    input clk,  
    input reset,  
    input [3:0] request,  // request signals for 4 channels  
    input [3:0] enable,   // enable signals for 4 channels  
    output reg [1:0] grant // grant signal for the highest priority channel  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            grant <= 2'b00;  
        end else begin  
            grant <= 2'b00;  
            if (enable[3] && request[3]) grant <= 2'b11;  
            else if (enable[2] && request[2]) grant <= 2'b10;  
            else if (enable[1] && request[1]) grant <= 2'b01;  
            else if (enable[0] && request[0]) grant <= 2'b00;  
        end  
    end  
endmodule