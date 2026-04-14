module shift_register (
    input clk,
    input reset,
    input [1:0] data_in,
    output reg [1:0] q_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_out <= 2'b00;
        end else begin
            q_out <= {q_out[0], data_in[0]}; // Shift left and input new data
        end
    end
endmodule