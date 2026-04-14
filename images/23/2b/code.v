module shift_register_2bit (  
    input wire clk,  
    input wire reset,  
    input wire shift,  
    input wire data_in,  
    output reg [1:0] data_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 2'b00;  
        end else if (shift) begin  
            data_out <= {data_in, data_out[1]};  
        end  
    end  
endmodule