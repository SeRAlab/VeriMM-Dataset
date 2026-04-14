module top_module(
    input req_aclk,
    input req_aresetn,

    output [C_ID_WIDTH-1:0] request_id,
    input [C_ID_WIDTH-1:0] response_id,

    input req_valid,
    output reg req_ready,
    input [C_BURSTS_PER_TRANSFER_WIDTH-1:0] req_burst_count,

    input enable,
    input pause,

    output eot
);parameter C_ID_WIDTH = 3;
parameter C_BURSTS_PER_TRANSFER_WIDTH = 17;

reg [C_BURSTS_PER_TRANSFER_WIDTH-1:0] burst_count = 'h00;
reg [C_ID_WIDTH-1:0] id;
wire [C_ID_WIDTH-1:0] id_next;

function [C_ID_WIDTH-1:0] inc_id;
    input [C_ID_WIDTH-1:0] current_id;
    begin
        inc_id = current_id + 1;
    end
endfunction

assign eot = burst_count == 'h00;
assign request_id = id;

always @(posedge req_aclk)
begin
    if (req_aresetn == 1'b0) begin
        burst_count <= 'h00;
        id <= 'h0;
        req_ready <= 1'b1;
    end else if (enable == 1'b0) begin
        req_ready <= 1'b1;
    end else begin
        if (req_ready) begin
            if (req_valid && enable) begin
                burst_count <= req_burst_count;
                req_ready <= 1'b0;
            end
        end else if (response_id != id_next && ~pause) begin
            if (eot)
                req_ready <= 1'b1;
            burst_count <= burst_count - 1'b1;
            id <= id_next;
        end
    end
end

assign id_next = inc_id(id);

endmodule