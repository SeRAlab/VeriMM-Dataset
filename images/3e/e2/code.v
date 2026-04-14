module pipo_shift_register (  
    input wire clk,  
    input wire reset,  
    input wire load,  
    input wire [4:0] data_in,  
    output reg [4:0] data_out,  
    output reg serial_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 5'b00000;  
            serial_out <= 1'b0;  
        end else if (load) begin  
            data_out <= data_in;  
            serial_out <= data_in[0];  
        end else begin  
            serial_out <= data_out[0];  
            data_out <= {1'b0, data_out[4:1]};  
        end  
    end  
endmodule