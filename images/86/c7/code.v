module top_module(
    input clk,
    input reset,
    input [3:0] InVec,
    input load,
    input start,
    output done,
    output [3:0] OutVec
);reg [3:0] reg_InVec;
reg [1:0] shift_count;
wire [3:0] shifted_value;

assign done = (shift_count == 2);

always @(posedge clk) begin
    if (reset) begin
        reg_InVec <= 4'b0;
        shift_count <= 2'b0;
    end else if (load) begin
        reg_InVec <= InVec;
        shift_count <= 2'b0;
    end else if (start && (shift_count < 2)) begin
        reg_InVec <= shifted_value;
        shift_count <= shift_count + 1;
    end
end

assign shifted_value = {reg_InVec[1:0], 2'b0};

assign OutVec = (shift_count == 2) ? shifted_value : reg_InVec;

endmodule