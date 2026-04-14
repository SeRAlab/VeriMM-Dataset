module shift_register (  
    input wire clk,  
    input wire load,  
    input wire shift,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  

    always @(posedge clk) begin  
        if (load) begin  
            data_out <= data_in;  
        end else if (shift) begin  
            data_out <= {data_out[14:0], 1'b0};  
        end  
    end  
endmodule