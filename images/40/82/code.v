module viterbi_decoder(
    input wire clk,
    input wire reset,
    input wire [3:0] input_data,
    output reg [1:0] output_data
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            output_data <= 0;
        end else begin
            case (state)
                2'b00: begin
                    if (input_data == 4'b0001) begin
                        output_data <= 2'b00;
                        state <= 2'b01;
                    end else begin
                        output_data <= 2'b01;
                        state <= 2'b10;
                    end
                end
                2'b01: begin
                    if (input_data == 4'b0010) begin
                        output_data <= 2'b10;
                        state <= 2'b00;
                    end else begin
                        output_data <= 2'b11;
                        state <= 2'b11;
                    end
                end
                2'b10: begin
                    output_data <= 2'b00;
                    state <= 2'b00;
                end
                2'b11: begin
                    output_data <= 2'b01;
                    state <= 2'b01;
                end
            endcase
        end
    end
endmodule