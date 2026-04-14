module top_module(
    input [15:0] a,
    input ready,
    input [1:0] iterations,
    output reg valid,
    output reg [15:0] result
);reg [15:0] x;
reg [15:0] x_next;
reg [15:0] temp;
reg [1:0] count;

always @ (posedge ready) begin
    x <= a;
    count <= 0;
end

always @ (posedge ready) begin
    if (count < iterations) begin
        temp = x_next;
        x_next = (x + (a / x)) / 2;
        x = temp;
        count = count + 1;
    end
end

always @ (posedge ready) begin
    if (count == iterations) begin
        valid = 1;
        result = x_next;
    end else begin
        valid = 0;
    end
end

endmodule