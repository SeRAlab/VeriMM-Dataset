module top_module(
    input clk,
    input reset,
    input [31:0] inst,
    input stall,
    output reg [31:0] ipc,
    output reg [31:0] cpi
);reg [31:0] inst_count;
reg [31:0] cycle_count;
reg [31:0] stalled_cycle_count;

always @(posedge clk) begin
    if (reset) begin
        inst_count <= 0;
        cycle_count <= 0;
        stalled_cycle_count <= 0;
    end else begin
        inst_count <= inst_count + 1;
        cycle_count <= cycle_count + 1;
        if (stall) begin
            stalled_cycle_count <= stalled_cycle_count + 1;
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        ipc <= 0;
        cpi <= 0;
    end else begin
        if (cycle_count - stalled_cycle_count == 0) begin
            ipc <= 0;
        end else begin
            ipc <= inst_count / (cycle_count - stalled_cycle_count);
        end
        if (inst_count == 0) begin
            cpi <= 0;
        end else begin
            cpi <= (cycle_count - stalled_cycle_count) / inst_count;
        end
    end
end

endmodule