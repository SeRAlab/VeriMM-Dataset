module sd_card_controller (
    input clk,
    input reset,
    input cmd,  // 1 for read, 0 for write
    output reg sd_busy
);
    reg [2:0] count; // 3 bits for counting cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sd_busy <= 0;
            count <= 0;
        end else begin
            if (sd_busy) begin
                if (count > 0) begin
                    count <= count - 1;
                    if (count == 1) begin
                        sd_busy <= 0; // Finished processing
                    end
                end
            end else begin
                if (cmd) begin  // Read command
                    count <= 3;
                    sd_busy <= 1;
                end else begin  // Write command
                    count <= 5;
                    sd_busy <= 1;
                end
            end
        end
    end
endmodule