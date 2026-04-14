module qam_modulator (
    input [3:0] data_in,
    input clk,
    output reg [1:0] mod_out
);  
    always @(posedge clk) begin  
        case (data_in[1:0])  
            2'b00: mod_out <= 2'b00;  
            2'b01: mod_out <= 2'b01;  
            2'b10: mod_out <= 2'b10;  
            2'b11: mod_out <= 2'b11;  
            default: mod_out <= 2'b00;  
        endcase  
    end  
endmodule