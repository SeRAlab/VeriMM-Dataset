module top_module(
    input wire l0, l1,
    output wire le,
    input wire r0, r1
);reg [1:0] buffer;
reg [1:0] delay_buffer;

always @(posedge le) begin
    delay_buffer <= buffer;
end

always @(posedge le or negedge le) begin
    if (!le) begin
        buffer <= {l1, l0};
    end
end

assign r0 = delay_buffer[0];
assign r1 = delay_buffer[1];

endmodule