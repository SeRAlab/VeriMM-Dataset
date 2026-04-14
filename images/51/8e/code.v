module d_flip_flop(
    input clk,
    input reset,
    input d,
    output reg q
    );

    always @(posedge clk) begin
        if (reset) 
            q <= 0;
        else 
            q <= d;
    end
endmodule

module binary_up_counter(
    input clk,
    input reset,
    output [2:0] count
    );

    wire [2:0] d;

    assign d[0] = ~count[0];
    assign d[1] = count[0] ^ count[1];
    assign d[2] = count[2] ^ (count[0] & count[1]);

    d_flip_flop ff0 (.clk(clk), .reset(reset), .d(d[0]), .q(count[0]));
    d_flip_flop ff1 (.clk(clk), .reset(reset), .d(d[1]), .q(count[1]));
    d_flip_flop ff2 (.clk(clk), .reset(reset), .d(d[2]), .q(count[2]));
endmodule