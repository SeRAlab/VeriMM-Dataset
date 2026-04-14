module top_module(
    input clk,
    input areset,
    input load,
    input shift_right,
    input shift_enable,
    input [3:0] data_in,
    output [3:0] data_out,
    output full
);reg [3:0] register;

always @(posedge clk or negedge areset) begin
    if (!areset) begin
        register <= 4'b0000;
    end else if (load) begin
        register <= data_in;
    end else if (shift_enable) begin
        if (shift_right) begin
            register <= {register[2:0], 1'b0}; // Shift right and fill with 0
        end else begin
            register <= {1'b0, register[3:1]}; // Shift left and fill with 0
        end
    end
end

assign data_out = register;

assign full = (register == 4'b1111);

endmodule