module shift_register_2bit(  
    input clk,  
    input [1:0] data_in,  
    output reg [1:0] data_out  
);  
    always @(posedge clk) begin  
        data_out <= {data_out[0], data_in[1]};  
    end  
endmodule