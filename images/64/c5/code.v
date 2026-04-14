module top_module(
    input [3:0] DATA_IN,
    input SHIFT_EN,
    input LOAD_EN,
    input CLK,
    output [3:0] DATA_OUT
);reg [3:0] reg_data;

always @(posedge CLK) begin
    if (LOAD_EN) begin
        reg_data <= DATA_IN;
    end else if (SHIFT_EN) begin
        reg_data <= {reg_data[2:0], reg_data[3]};
    end
end

assign DATA_OUT = reg_data;

endmodule