module nvme_command_register (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [15:0] cid_in,
    input wire [3:0] ct_in,
    output reg [15:0] cid_out,
    output reg [3:0] ct_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cid_out <= 16'b0;
            ct_out <= 4'b0;
        end else if (load) begin
            cid_out <= cid_in;
            ct_out <= ct_in;
        end
    end
endmodule