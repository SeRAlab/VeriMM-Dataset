module shift_register(  
    input [1:0] data_in,  
    input control,  
    input clk,  
    output reg [1:0] data_out  
);  
    always @(posedge clk) begin  
        if (control) begin  
            data_out <= {1'b0, data_out[1]}; // Shift Right  
        end else begin  
            data_out <= {data_out[0], data_in}; // Shift Left  
        end  
    end  
endmodule