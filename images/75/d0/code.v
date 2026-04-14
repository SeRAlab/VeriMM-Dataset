module top_module(
    input wire clk,
    input wire rst,
    input wire AD,
    input wire [7:0] DI,
    output reg [7:0] DO,
    input wire rw,
    input wire cs,
    output reg [3:0] page,
    output reg rampage_lock,
    output reg sysboot_lock,
    output reg bram_disable,
    output reg brom_disable
);always @ (posedge clk) begin
        if (rst) begin
            page <= 4'b0000;
            rampage_lock <= 0;
            sysboot_lock <= 0;
            bram_disable <= 1;
            brom_disable <= 0;
        end else begin
            if (cs) begin
                if (rw) begin
                    if (AD) begin
                        rampage_lock <= DI[0];
                        sysboot_lock <= DI[1];
                        bram_disable <= DI[2];
                        brom_disable <= DI[3];
                    end else begin
                        DO[3:0] <= {brom_disable, bram_disable, sysboot_lock, rampage_lock};
                    end
                end else begin
                    if (AD) begin
                        page <= DI[3:0];
                    end else begin
                        DO[7:0] <= 8'b0;
                        DO[3:0] <= page;
                    end
                end
            end
        end
    end

endmodule