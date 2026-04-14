module md5_transformer(  
    input wire [31:0] data_in,  
    input wire control,  
    input wire reset,  
    output reg [31:0] data_out  
);  
    always @(posedge control or posedge reset) begin  
        if (reset) begin  
            data_out <= 32'b0;  
        end else begin  
            data_out <= data_in ^ 32'hA0A0A0A0;  
        end  
    end  
endmodule