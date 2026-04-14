module up_counter (
    input CLK,
    input CLR,
    output reg [3:0] Q
);

    always @(posedge CLK) begin
        if (CLR) begin
            Q <= 4'b0;
        end else begin
            Q <= Q + 1;
        end
    end

endmodule