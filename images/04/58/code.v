module shift_register(  
    input clk,  
    input load_en,  
    input serial_in,  
    input [7:0] parallel_in,  
    output reg [7:0] parallel_out  
);  
    always @(posedge clk) begin  
        if (load_en) begin  
            parallel_out <= parallel_in;  
        end else begin  
            parallel_out <= {serial_in, parallel_out[7:1]};  
        end  
    end  
endmodule