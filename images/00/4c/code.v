module turbo_encoder(
    input clk,
    input reset,
    input [1:0] data_in,
    output reg [3:0] encoded_out
);

reg [1:0] state1, state2;
reg [1:0] encoded1, encoded2;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state1 <= 2'b00;
        state2 <= 2'b00;
        encoded_out <= 4'b0000;
    end else begin
        // Simple encoding logic for state1
        case (data_in)
            2'b00: encoded1 = 2'b00;
            2'b01: encoded1 = 2'b01;
            2'b10: encoded1 = 2'b10;
            2'b11: encoded1 = 2'b11;
            default: encoded1 = 2'b00;
        endcase
        
        // Simple encoding logic for state2 (interleaved)
        encoded2 = {data_in[1], data_in[0]}; // Simple example, swap bits

        encoded_out <= {encoded1, encoded2};
    end
end

endmodule