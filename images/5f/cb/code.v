module top_module(
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        a,
        b,
        ap_return
);input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [15:0] a;
input  [15:0] b;
output  [31:0] ap_return;

parameter    ap_const_logic_1 = 1'b1;
parameter    ap_const_logic_0 = 1'b0;

reg [31:0] result;
reg [3:0] counter;

assign ap_done = (counter == 16) ? ap_const_logic_1 : ap_const_logic_0;
assign ap_idle = (counter == 0) ? ap_const_logic_1 : ap_const_logic_0;
assign ap_ready = (counter == 0) ? ap_const_logic_1 : ap_const_logic_0;
assign ap_return = result;

always @ (posedge ap_start) begin
    result <= 0;
    counter <= 0;
end

always @ (posedge ap_start) begin
    for (counter = 0; counter < 16; counter = counter + 1) begin
        if (b[counter] == ap_const_logic_1) begin
            result <= result + (a << counter);
        end
    end
end

endmodule