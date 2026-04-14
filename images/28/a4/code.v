module wifi_controller(  
    input wire clk,  
    input wire reset,  
    input wire [2:0] status,  
    output reg active  
);  

always @(posedge clk or posedge reset) begin  
    if (reset)  
        active <= 0;  
    else begin  
        if (status == 3'b010)  // Check if status is CONNECTED (2 in binary)  
            active <= 1;  
        else  
            active <= 0;  
    end  
end  
endmodule