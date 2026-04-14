module priority_encoder(
    input wire [3:0] data_in,    
    output reg [1:0] encoded_out
);

    always @(*) begin
        casez (data_in)
            4'b1???: encoded_out = 2'b11;
            4'b01??: encoded_out = 2'b10;
            4'b001?: encoded_out = 2'b01;
            4'b0001: encoded_out = 2'b00;
            default: encoded_out = 2'b00;
        endcase
    end
endmodule