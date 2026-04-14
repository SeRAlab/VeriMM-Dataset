module deserializer_32bit (  
    input clk,  
    input reset,  
    input enable,  
    input [7:0] data_in,  
    output reg [31:0] data_out,  
    output reg valid  
);  
  
    reg [1:0] count;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 32'b0;  
            count <= 2'b0;  
            valid <= 0;  
        end else if (enable) begin  
            data_out <= {data_out[23:0], data_in}; // Shift in new data  
            count <= count + 1;  
            if (count == 2'b11) begin  
                valid <= 1;  
            end else begin  
                valid <= 0;  
            end  
        end  
    end  
endmodule