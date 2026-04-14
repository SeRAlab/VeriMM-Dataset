module top_module(
    input clock,
    input clrn,
    input d,
    input ena,
    output q
    );reg [2:0] stage_data;

    always @(posedge clock) begin
        if (clrn == 1'b0) begin
            stage_data <= 3'b0;
        end else if (ena == 1'b1) begin
            stage_data[2] <= d;
            stage_data[1] <= stage_data[2];
            stage_data[0] <= stage_data[1];
        end
    end

    assign q = stage_data[0];

endmodule