module top_module(
    input  wire         clk,
    input  wire         reset,
    input  wire  [3:0]  async_data,
    output reg          async_ack,
    output reg   [1:0]  sync_data,
    output reg          sync_en
);reg  [3:0] async_data_d1, async_data_d2;
    wire async_req_d0, async_sp_d0;
    reg  async_req_d1, async_sp_d1;
    wire async_req_edge, async_sp_edge;


    always @(posedge clk) begin
        if (reset == 1'b1) begin
            async_data_d1 <= 4'b0;
            async_data_d2 <= 4'b0;
        end else begin
            async_data_d1 <= async_data;
            async_data_d2 <= async_data_d1;
        end
    end


    assign async_req_d0 = (async_data_d2[0] | async_data_d2[1]) & (async_data_d2[2] | async_data_d2[3]);
    assign async_sp_d0  = ~(async_data_d2[0] | async_data_d2[1]) & ~(async_data_d2[2] | async_data_d2[3]);

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            async_req_d1 <= 1'b0;
            async_sp_d1  <= 1'b0;
        end else begin
            async_req_d1 <= async_req_d0;
            async_sp_d1  <= async_sp_d0;
        end
    end

    assign async_req_edge = ~async_req_d1 & async_req_d0;
    assign async_sp_edge = ~async_sp_d1 & async_sp_d0;


    always @(posedge clk) begin
        if (reset == 1'b1) begin
            async_ack <= 1'b0;
            sync_data <= 2'b0;
            sync_en   <= 1'b0;
        end else begin
            if (async_req_edge == 1'b1) begin
                async_ack <= 1'b1;
                sync_data <= {async_data_d2[3], async_data_d2[1]};
                sync_en   <= 1'b1;
            end else if (async_sp_edge == 1'b1) begin
                async_ack <= 1'b0;
                sync_data <= 2'b0;
                sync_en <= 1'b0;
            end else begin
                sync_en <= 1'b0;
            end
        end
    end

endmodule