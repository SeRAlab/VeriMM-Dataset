module top_module(
    input CLK,
    output reg Q0,
    output reg Q1,
    output reg Q2,
    output reg Q3
);reg [3:0] reg_Q;

always @(posedge CLK) begin
    reg_Q <= {reg_Q[2:0], reg_Q[3] ^ reg_Q[2]};
end

assign Q0 = reg_Q[0];
assign Q1 = reg_Q[1];
assign Q2 = reg_Q[2];
assign Q3 = reg_Q[3];

endmodule