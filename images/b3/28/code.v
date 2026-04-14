module top_module(
    input [7:0] data_in,
    input [1:0] shift_amount,
    input select,
    input clk, // Added clk input
    output reg [7:0] data_out // Changed to reg to match assignment in always block
);reg [7:0] stage1_out;
reg [7:0] stage2_out;

always @(*) begin
    case (shift_amount)
        2'b00: stage1_out = data_in;
        2'b01: stage1_out = {data_in[6:0], data_in[7]};
        2'b10: stage1_out = {data_in[7:1], data_in[0]}; // Corrected part select order
        2'b11: stage1_out = {data_in[0], data_in[7:1]};
    endcase
end

always @(posedge clk) begin
    if (select == 1'b0) begin
        stage2_out <= stage1_out << shift_amount;
    end else begin
        stage2_out <= stage1_out >> shift_amount;
    end
end

always @(posedge clk) begin
    data_out <= stage2_out; // Assign stage2_out to data_out on the rising edge of clk
end

endmodule