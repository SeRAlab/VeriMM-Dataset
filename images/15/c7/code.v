module sipo_shift_register (
    input clk,
    input reset,
    input data,
    input load,
    output reg [4:0] parallel_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parallel_out <= 5'b00000;
        end else if (load) begin
            parallel_out <= {parallel_out[3:0], data};
        end
    end
endmodule