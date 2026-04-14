module deadbeat_controller(  
    input clk,  
    input reset,  
    input [1:0] input_val,  
    output reg [1:0] output_val  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        output_val <= 2'b00;  
    end else begin  
        output_val <= input_val;  
    end  
end  
endmodule