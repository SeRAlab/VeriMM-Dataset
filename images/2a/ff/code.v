module shift_register (  
    input clk,  
    input [1:0] data_in,  
    output reg [1:0] q  
);  
    always @(posedge clk) begin  
        q <= {data_in[1], q[1]};  
    end  
endmodule