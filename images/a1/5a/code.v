module top_module(
    input clock0,
    input clock180,
    input reset,
    input countu,
    input countd,
    output reg [7:0] nr_presses
);reg [7:0] press_count;

always @(posedge clock0, negedge reset) begin
    if (reset == 0) begin
        press_count <= 0;
    end else if (countu == 1) begin
        press_count <= press_count + 1;
    end else if (countd == 1) begin
        press_count <= press_count - 1;
    end
end

always @(posedge clock180) begin
    nr_presses <= press_count;
end

endmodule