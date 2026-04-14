module qam_modulator(  
    input clk,  
    input reset,  
    input [3:0] symbol_in,  
    output reg [1:0] i_out,  
    output reg [1:0] q_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            i_out <= 2'b00;  
            q_out <= 2'b00;  
        end else begin  
            case (symbol_in)  
                4'b0000: begin i_out <= 2'b00; q_out <= 2'b00; end  
                4'b0001: begin i_out <= 2'b00; q_out <= 2'b01; end  
                4'b0010: begin i_out <= 2'b01; q_out <= 2'b00; end  
                4'b0011: begin i_out <= 2'b01; q_out <= 2'b01; end  
                4'b0100: begin i_out <= 2'b10; q_out <= 2'b00; end  
                4'b0101: begin i_out <= 2'b10; q_out <= 2'b01; end  
                4'b0110: begin i_out <= 2'b11; q_out <= 2'b00; end  
                4'b0111: begin i_out <= 2'b11; q_out <= 2'b01; end  
                4'b1000: begin i_out <= 2'b00; q_out <= 2'b10; end  
                4'b1001: begin i_out <= 2'b00; q_out <= 2'b11; end  
                4'b1010: begin i_out <= 2'b01; q_out <= 2'b10; end  
                4'b1011: begin i_out <= 2'b01; q_out <= 2'b11; end  
                4'b1100: begin i_out <= 2'b10; q_out <= 2'b10; end  
                4'b1101: begin i_out <= 2'b10; q_out <= 2'b11; end  
                4'b1110: begin i_out <= 2'b11; q_out <= 2'b10; end  
                4'b1111: begin i_out <= 2'b11; q_out <= 2'b11; end  
                default: begin i_out <= 2'b00; q_out <= 2'b00; end  
            endcase  
        end  
    end  
endmodule