module convolutional_encoder(
    input clk,
    input rst,
    input data_in,
    output reg [1:0] data_out
);
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            data_out <= 2'b00;
        end else begin
            // Transition to next state and produce output
            case (state)
                2'b00: begin
                    data_out <= {data_in ^ 1'b0, data_in ^ 1'b1}; // Example polynomials
                    state <= (data_in) ? 2'b01 : 2'b00;
                end
                2'b01: begin
                    data_out <= {data_in ^ 1'b1, data_in ^ 1'b0};
                    state <= (data_in) ? 2'b10 : 2'b00;
                end
                2'b10: begin
                    data_out <= {data_in ^ 1'b1, data_in ^ 1'b1};
                    state <= (data_in) ? 2'b11 : 2'b00;
                end
                2'b11: begin
                    data_out <= {data_in ^ 1'b0, data_in ^ 1'b0};
                    state <= 2'b00;
                end
                default: begin
                    state <= 2'b00;
                end
            endcase
        end
    end
endmodule