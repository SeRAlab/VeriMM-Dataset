module simple_des_encryption(  
    input wire clk,  
    input wire rst,  
    input wire [63:0] data_in,  
    input wire [31:0] key,  
    output reg [63:0] data_out  
);  

reg [31:0] left_half, right_half;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        data_out <= 64'b0;  
    end else begin  
        left_half <= data_in[63:32] ^ key;  
        right_half <= data_in[31:0] ^ key;  
        left_half <= {left_half[30:0], left_half[31]}; // shift left  
        right_half <= {right_half[0], right_half[31:1]}; // rotate right  
        data_out <= {left_half, right_half};  
    end  
end  
endmodule