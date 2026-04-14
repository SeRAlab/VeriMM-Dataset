module register_4bit (  
    input wire clk,  
    input wire enable,  
    input wire [3:0] data_in,  
    output reg [3:0] data_out  
);  
    always @(posedge clk) begin  
        if (enable)  
            data_out <= data_in;  
    end  
endmodule