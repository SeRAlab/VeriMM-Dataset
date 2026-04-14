module turbo_encoder (
    input clk,
    input reset,
    input data_in,
    output reg [3:0] codeword_out
);
    reg [1:0] state;
    reg [1:0] interleaved_out;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            codeword_out <= 4'b0000;
        end else begin
            // Example encoding logic
            case (state)
                2'b00: begin
                    interleaved_out <= {data_in, ~data_in}; // Example 2-bit
                    state <= 2'b01;
                end
                2'b01: begin
                    codeword_out <= {interleaved_out, interleaved_out}; // 4-bit output
                    state <= 2'b00;
                end
                default: state <= 2'b00;
            endcase
        end
    end
endmodule