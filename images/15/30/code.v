module shift_register_2bit (  
    input clk,  
    input rst,  
    input load,  
    input [1:0] din,  
    output reg [1:0] dout  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            dout <= 2'b00;  
        end else if (load) begin  
            dout <= din;  
        end else begin  
            dout <= {1'b0, dout[1]}; // Shift right  
        end  
    end  
endmodule