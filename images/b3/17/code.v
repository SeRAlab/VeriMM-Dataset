module top_module(
    input clk,
    input load,
    input shift_left,
    input shift_right,
    input reset,
    input [3:0] data_in,
    output [3:0] data_out
);reg [3:0] pipeline_reg [0:2];
reg [1:0] stage;

always @(posedge clk) begin
    if (reset) begin
        pipeline_reg[0] <= 4'b0000;
        pipeline_reg[1] <= 4'b0000;
        pipeline_reg[2] <= 4'b0000;
        stage <= 2'b00;
    end else begin
        case (stage)
            2'b00: begin
                if (load) begin
                    pipeline_reg[0] <= data_in;
                end
                stage <= shift_left ? 2'b01 : shift_right ? 2'b10 : 2'b00;
            end
            2'b01: begin
                pipeline_reg[1] <= pipeline_reg[0];
                stage <= 2'b10;
            end
            2'b10: begin
                pipeline_reg[2] <= pipeline_reg[1];
                stage <= 2'b00;
            end
        endcase
    end
end

assign data_out = pipeline_reg[2];

endmodule