module shift_register (  
    input clk,  
    input rst,  
    input serial_in,  
    output reg [1:0] data  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            data <= 2'b00;  
        end else begin  
            data <= {data[0], serial_in};  
        end  
    end  
endmodule