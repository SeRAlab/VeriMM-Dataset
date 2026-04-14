module pipelined_register (
    input clk,
    input reset,
    input [15:0] data_in,
    output [15:0] data_out
);

    reg [15:0] pipeline [0:3];  // 4-stage pipeline

    always @(posedge clk) begin
        if (reset) begin
            pipeline[0] <= 16'b0;
            pipeline[1] <= 16'b0;
            pipeline[2] <= 16'b0;
            pipeline[3] <= 16'b0;
        end else begin
            pipeline[0] <= data_in;
            pipeline[1] <= pipeline[0];
            pipeline[2] <= pipeline[1];
            pipeline[3] <= pipeline[2];
        end
    end

    assign data_out = pipeline[3];

endmodule