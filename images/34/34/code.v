module QAM_Modulator(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] data_in,  
    output reg signed [1:0] I_out,  
    output reg signed [1:0] Q_out  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            I_out <= 2'b00;  
            Q_out <= 2'b00;  
        end else begin  
            case (data_in)  
                4'b0000: begin I_out <= 2'b01; Q_out <= 2'b01; end  
                4'b0001: begin I_out <= 2'b01; Q_out <= 2'b10; end  
                4'b0010: begin I_out <= 2'b10; Q_out <= 2'b01; end  
                4'b0011: begin I_out <= 2'b10; Q_out <= 2'b10; end  
                4'b0100: begin I_out <= 2'b01; Q_out <= 2'b00; end  
                4'b0101: begin I_out <= 2'b01; Q_out <= 2'b11; end  
                4'b0110: begin I_out <= 2'b10; Q_out <= 2'b00; end  
                4'b0111: begin I_out <= 2'b10; Q_out <= 2'b11; end  
                4'b1000: begin I_out <= 2'b00; Q_out <= 2'b01; end  
                4'b1001: begin I_out <= 2'b00; Q_out <= 2'b10; end  
                4'b1010: begin I_out <= 2'b11; Q_out <= 2'b01; end  
                4'b1011: begin I_out <= 2'b11; Q_out <= 2'b10; end  
                4'b1100: begin I_out <= 2'b00; Q_out <= 2'b00; end  
                4'b1101: begin I_out <= 2'b00; Q_out <= 2'b11; end  
                4'b1110: begin I_out <= 2'b11; Q_out <= 2'b00; end  
                4'b1111: begin I_out <= 2'b11; Q_out <= 2'b11; end  
                default: begin I_out <= 2'b00; Q_out <= 2'b00; end  
            endcase  
        end  
    end  
endmodule