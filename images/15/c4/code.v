module shift_register(  
    input wire clk,  
    input wire reset,  
    input wire load,  
    input wire shift_en,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        data_out <= 16'b0;  
    end else if (load) begin  
        data_out <= data_in;  
    end else if (shift_en) begin  
        data_out <= {1'b0, data_out[15:1]};  
    end  
end  
endmodule