module conv_encoder (
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
            state <= {state[0], data_in}; // Shift in the new data
            data_out <= {state[1] ^ state[0], state[0]}; // Generate output
        end
    end
endmodule