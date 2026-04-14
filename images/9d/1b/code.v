module priority_encoder (
    input [3:0] bin,
    output reg [1:0] encoded);
    
    always @(*) begin
        case (bin)
            4'b1000: encoded = 2'b11;
            4'b0100: encoded = 2'b10;
            4'b0010: encoded = 2'b01;
            4'b0001: encoded = 2'b00;
            default: encoded = 2'b00;
        endcase
    end
    
endmodule