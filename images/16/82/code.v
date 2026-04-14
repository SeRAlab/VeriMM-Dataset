module vco (  
    input clk,  
    input reset,  
    input [1:0] control,  
    output reg freq_out  
);  
    reg [1:0] state;  
    parameter low_freq = 0, high_freq = 1;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 2'b00;  
            freq_out <= 0;  
        end else begin  
            case (control)  
                2'b00: begin  
                    state <= low_freq;  
                    freq_out <= 0;  
                end  
                2'b01: begin  
                    state <= low_freq;  
                    freq_out <= ~freq_out;  
                end  
                2'b10: begin  
                    state <= high_freq;  
                    freq_out <= 1;  
                end  
                2'b11: begin  
                    state <= high_freq;  
                    freq_out <= ~freq_out;  
                end  
                default: begin  
                    state <= 2'b00;  
                    freq_out <= 0;  
                end  
            endcase  
        end  
    end  
endmodule