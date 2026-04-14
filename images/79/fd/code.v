module top_module(
    input wire D,
    input wire CLK,
    input wire DE,
    input wire SET,
    input wire RESET,
    output reg Q,
    output reg Q_N
);wire mux_out;
    assign mux_out = DE ? D : 1'b0;
    
    always @(posedge CLK) begin
        if (SET) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else if (RESET) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else begin
            Q <= mux_out;
            Q_N <= ~mux_out;
        end
    end

endmodule