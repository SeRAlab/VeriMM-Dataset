module reset_controller(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] value,  
    output reg [3:0] out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            out <= 4'b0000;  
        else  
            out <= value;  
    end  
endmodule