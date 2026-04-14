module top_module(
    output out_Y,
    input in_A1,
    input in_A2,
    input in_B1_N
);// Internal 32-bit counter register
    reg [31:0] counter = 0;

    always @ (in_A1 or in_A2 or in_B1_N) begin
        if (in_A1 && in_A2) begin
            counter <= counter + 1;
        end else if (in_B1_N) begin
            counter <= 0;
        end
    end

    assign out_Y = counter % 2;

endmodule