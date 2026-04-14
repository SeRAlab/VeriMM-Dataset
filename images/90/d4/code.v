module top_module(
    input [3:0] I,
    output reg valid, // Changed from wire to reg
    output reg [1:0] encoded_value
);always @(*) begin
    case (I)
        4'b0001: encoded_value = 2'b00;
        4'b0010: encoded_value = 2'b01;
        4'b0100: encoded_value = 2'b10;
        4'b1000: encoded_value = 2'b11;
        default: encoded_value = 2'b00;
    endcase
    
    if (I != 4'b0000) begin
        valid = 1;
    end else begin
        valid = 0;
    end
end

endmodule