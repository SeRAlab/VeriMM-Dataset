module shift_register (  
    input clk,  
    input load,  
    input [7:0] data_in,  
    output reg [7:0] q,  
    output reg serial_out  
);  
    always @(posedge clk) begin  
        if (load)  
            q <= data_in;  
        else begin  
            serial_out <= q[0];  
            q <= {1'b0, q[7:1]};  
        end  
    end  
endmodule