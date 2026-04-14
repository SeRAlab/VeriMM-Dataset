module dma_controller (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] request,  
    input wire enable,  
    output reg [2:0] grant  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            grant <= 3'b000;  
        end else if (enable) begin  
            grant <= (request[0]) ? 3'b000 :  
                      (request[1]) ? 3'b001 :  
                      (request[2]) ? 3'b010 :  
                      (request[3]) ? 3'b011 :  
                      (request[4]) ? 3'b100 :  
                      (request[5]) ? 3'b101 :  
                      (request[6]) ? 3'b110 :  
                      (request[7]) ? 3'b111 :  
                      3'b000;  
        end  
    end  
endmodule