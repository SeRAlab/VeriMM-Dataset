module nvme_controller_status (
    input [2:0] cmd_status,
    output reg led_status
);

always @(*) begin
    case (cmd_status)
        3'b000: led_status = 1'b0; // idle
        3'b001: led_status = 1'b1; // in progress (yellow)
        3'b010: led_status = 1'b1; // completed (green)
        default: led_status = 1'b0; // default to off for any other status
    endcase
end

endmodule