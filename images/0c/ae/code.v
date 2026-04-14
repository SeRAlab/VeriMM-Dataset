module register_16bit (  
    input wire clk,  
    input wire enable,  
    input wire [15:0] data_in,  
    output reg [15:0] data_out,  
    output reg is_even  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            data_out <= data_in;  
        end  
        is_even <= ~data_out[0];  
    end  
endmodule