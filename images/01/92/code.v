module sd_card_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in1,
    input wire [7:0] data_in2,
    output reg [7:0] data_out
);

reg [7:0] data_reg1;
reg [7:0] data_reg2;
reg [7:0] prev_data_in1;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_reg1 <= 8'b0;
        data_reg2 <= 8'b0;
        data_out <= 8'b0;
        prev_data_in1 <= 8'b0;
    end else begin
        data_reg1 <= data_in1;
        data_reg2 <= data_in2;

        if (data_reg1 != prev_data_in1) begin
            data_out <= data_reg1;
            prev_data_in1 <= data_reg1;
        end
    end
end

endmodule