module shift_register (  
    input wire clk,  
    input wire rst,  
    input wire load,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            data_out <= 16'b0;  
        else if (load)  
            data_out <= data_in;  
        else  
            data_out <= {data_out[14:0], 1'b0};  
    end  
endmodule