module top_module(CLK, T, R, Q, Qn);parameter T_HIGH = 1'b1;
parameter RESET_HIGH = 1'b1;
parameter RESET_DELAY = 2;

input CLK;
input T;
input R;
output Q;
output Qn;

reg Q_reg;
reg Qn_reg;
reg [1:0] reset_counter;

wire Tn;
not(Tn, T);

assign Q = Q_reg;
assign Qn = Qn_reg;

always @(posedge CLK) begin
    if (R == RESET_HIGH) begin
        reset_counter <= 0;
        Q_reg <= 0;
        Qn_reg <= 1;
    end else if (reset_counter < RESET_DELAY) begin
        reset_counter <= reset_counter + 1;
    end else if (T == T_HIGH) begin
        Q_reg <= ~Q_reg;
        Qn_reg <= ~Qn_reg;
    end
end

endmodule