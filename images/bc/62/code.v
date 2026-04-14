module top_module(
    input clk,
    input rst,
    input shift,
    input dir,
    input [3:0] in,
    output [3:0] out,
    output [3:0] shifted_out
);reg [3:0] reg_out;
reg [3:0] reg_shifted_out;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg_out <= 4'b0;
        reg_shifted_out <= 4'b0;
    end else begin
        if (shift) begin
            if (dir) begin
                reg_shifted_out <= reg_out[3];
                reg_out <= {reg_out[2:0], in};
            end else begin
                reg_shifted_out <= reg_out[0];
                reg_out <= {in, reg_out[3:1]};
            end
        end else begin
            reg_out <= in;
            reg_shifted_out <= 4'b0;
        end
    end
end

assign out = reg_out;
assign shifted_out = reg_shifted_out;

endmodule