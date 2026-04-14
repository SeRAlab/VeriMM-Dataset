module top_module(
    input CLK,
    input D,
    input SCD,
    input SCE,
    input RESET_B,
    output reg Q
);reg [1:0] delay_counter;

always @(posedge CLK) begin
    if (RESET_B == 0) begin
        Q <= 0;
        delay_counter <= 0;
    end else begin
        if (SCE == 1) begin
            if (delay_counter == 0) begin
                Q <= D;
                if (SCD == 1) begin
                    delay_counter <= 1;
                end
            end else begin
                Q <= Q;
                delay_counter <= 0;
            end
        end else begin
            Q <= D;
            delay_counter <= 0;
        end
    end
end

endmodule