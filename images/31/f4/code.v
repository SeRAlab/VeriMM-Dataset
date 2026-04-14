module bluetooth_encoder(  
    input [3:0] data,  
    input clk,  
    input reset,  
    output reg [3:0] encoded_data  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        encoded_data <= 4'b0000;  
    else begin  
        if (data < 4'b1000)  
            encoded_data <= data;  
        else  
            encoded_data <= data ^ 4'b1010;  
    end  
end  
endmodule