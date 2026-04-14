module shift_register(input clk, reset, data, output reg q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b0;
        end else begin
            q <= {q[1:0], data};
        end
    end

endmodule