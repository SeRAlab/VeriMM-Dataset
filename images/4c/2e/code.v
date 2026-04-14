module top_module(
    input clk,
    input reset,
    input data,
    input select,
    output reg [3:0] counter_out,
    output reg [2:0] shift_register_out
);reg [3:0] counter;
reg [2:0] shift_register;

always @(posedge clk) begin
    if (reset) begin
        counter <= 4'b0000;
        shift_register <= 3'b000;
    end else begin
        if (select) begin
            counter <= counter + 1;
            shift_register <= shift_register;
        end else begin
            counter <= counter;
            shift_register <= {shift_register[1:0], data};
        end
    end
end

assign counter_out = counter;
assign shift_register_out = shift_register;

endmodule