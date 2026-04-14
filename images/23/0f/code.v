module qam_modulator (  
    input wire clk,  
    input wire I,  
    input wire Q,  
    output reg [3:0] output_signal  
);  

    always @(posedge clk) begin  
        case ({I, Q})  
            2'b00: output_signal <= 4'b0000;  
            2'b01: output_signal <= 4'b0001;  
            2'b10: output_signal <= 4'b0010;  
            2'b11: output_signal <= 4'b0011;  
            default: output_signal <= 4'b0000;  
        endcase  
    end  
endmodule