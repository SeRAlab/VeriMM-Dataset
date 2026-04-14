module top_module(
    output reg q,
    input S,
    input E,
    input rst
);wire n_0;
wire n_1;
wire E_;

assign E_ = E & ~rst;       // Implementing AND2
assign n_0 = E_ & S;        // Implementing AND2
assign n_1 = E_ & ~S;       // Implementing AND2

always @(posedge E_ or posedge rst) begin
    if (rst) begin
        q <= 0;              // Reset q to 0
    end else begin
        q <= ~(n_0 | q);     // Implementing NOR2
    end
end

endmodule