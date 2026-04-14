module top_module(
    input wire D,
    input wire SCD,
    input wire SCE,
    input wire CLK,
    output reg Q,
    output reg Q_N
);reg mux_out;
    reg [1:0] state;

    always @(posedge CLK) begin
        case (state)
            2'b00: begin
                mux_out <= D;
                Q <= mux_out;
                Q_N <= ~mux_out;
                if (SCE && !SCD) begin
                    state <= 2'b01;
                end else if (SCD && !SCE) begin
                    state <= 2'b10;
                end
            end
            2'b01: begin
                mux_out <= 1'b1;
                Q <= mux_out;
                Q_N <= ~mux_out;
                if (!SCE) begin
                    state <= 2'b00;
                end
            end
            2'b10: begin
                mux_out <= 1'b0;
                Q <= mux_out;
                Q_N <= ~mux_out;
                if (!SCD) begin
                    state <= 2'b00;
                end
            end
        endcase
    end

endmodule