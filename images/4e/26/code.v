module top_module(clk, reset, parallel_load, shift_left, shift_right, parallel_input, q);input clk, reset, parallel_load, shift_left, shift_right;
    input [3:0] parallel_input;
    output [3:0] q;
    reg [3:0] register;

    always @(posedge clk) begin
        if (reset) begin
            register <= 4'b0000;
        end
        else begin
            if (parallel_load) begin
                register <= parallel_input;
            end
            else if (shift_left) begin
                register <= {register[2:0], 1'b0};
            end
            else if (shift_right) begin
                register <= {1'b0, register[3:1]};
            end
        end
    end

    assign q = register;

endmodule