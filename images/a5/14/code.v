module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q);reg [3:0] reg_data;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            reg_data <= 4'b0;
        end else if (load && ena) begin
            reg_data <= data;
        end else if (ena) begin
            reg_data <= {reg_data[2:0], reg_data[3]};
        end
    end

    assign q = reg_data;

endmodule