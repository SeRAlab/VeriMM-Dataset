module interrupt_controller (
    input wire clk,
    input wire rst,
    input wire [3:0] int_req,
    output reg [3:0] int_status,
    output reg int_pending
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        int_status <= 4'b0000;
        int_pending <= 1'b0;
    end else begin
        int_status <= int_status | int_req;
        int_pending <= |int_status; // Check if any interrupt is set
    end
end

endmodule