module ofdm_modulator (  
    input wire clk,  
    input wire [4:0] data_in,  
    output reg [4:0] data_out  
);  

    always @(posedge clk) begin  
        data_out <= {data_in[3:0], 1'b0};  
    end  
endmodule