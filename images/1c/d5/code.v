module shift_register(  
    input wire clk,  
    input wire load,  
    input wire shift_left,  
    input wire shift_right,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out  
);  
    always @(posedge clk) begin  
        if (load) begin  
            data_out <= data_in;  
        end else if (shift_left) begin  
            data_out <= {data_out[14:0], 1'b0};  
        end else if (shift_right) begin  
            data_out <= {1'b0, data_out[15:1]};  
        end  
    end  
endmodule