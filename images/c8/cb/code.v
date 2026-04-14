module up_counter(
    input CLK,
    input RST,
    output reg [1:0] Q
);

    always @(posedge CLK) begin
        if (RST) begin
            Q <= 2'b0;
        end else begin
            Q <= Q + 1;
        end
    end

endmodule