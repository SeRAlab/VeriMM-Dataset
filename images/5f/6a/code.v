module top_module(
    input rxReset,
    input rxClk,
    input bit0_r,
    input bit1_r,
    input bit0Enable,
    output reg [1:0] dq,
    output reg dqValid
);reg q0, q1, qen, qnfe;

always @(posedge rxClk) begin
    if(rxReset) begin
        q0 <= 0;
        q1 <= 0;
        qen <= 0;
        qnfe <= 0;
    end
    else begin
        q0 <= bit0_r;
        q1 <= bit1_r;
        qen <= bit0Enable;
        qnfe <= qen | qnfe;
    end
end

assign dq = {q1, q0};
assign dqValid = qen & qnfe;

endmodule