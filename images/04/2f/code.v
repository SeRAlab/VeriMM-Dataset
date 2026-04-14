module shift_register (  
    input clk,  
    input rst_n,  
    input load,  
    input shift,  
    input [31:0] data_in,  
    output reg [31:0] data_out  
);  

always @(posedge clk or negedge rst_n) begin  
    if (!rst_n) begin  
        data_out <= 32'b0;  
    end else if (load) begin  
        data_out <= data_in;  
    end else if (shift) begin  
        data_out <= {1'b0, data_out[31:1]}; // Shift right with zero fill  
    end  
end  
endmodule