module shift_register(  
    input clk,  
    input rst,  
    input dir,  
    input [15:0] data_in,  
    output reg [15:0] data_out  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            data_out <= data_in;  
        else if (dir == 0)  
            data_out <= {data_out[14:0], 1'b0}; // left shift  
        else  
            data_out <= {1'b0, data_out[15:1]}; // right shift  
    end  
endmodule