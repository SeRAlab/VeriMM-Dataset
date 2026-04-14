module top_module( 
    Reset,
    Clk,
    MAC_tx_addr_init,
    MAC_tx_addr_rd,
    MAC_tx_addr_data,
    MAC_add_prom_data,
    MAC_add_prom_add,
    MAC_add_prom_wr
);input           Reset;
    input           Clk;
    input           MAC_tx_addr_rd;
    input           MAC_tx_addr_init;
    output  [7:0]   MAC_tx_addr_data;
    input   [7:0]   MAC_add_prom_data;
    input   [2:0]   MAC_add_prom_add;
    input           MAC_add_prom_wr;

    // Internal signals
    reg [2:0]       add_rd;
    wire[2:0]       add_wr;
    wire[7:0]       din;
    reg [7:0]       dout;              // Change dout to reg
    wire            wr_en;
    reg             MAC_add_prom_wr_dl1;
    reg             MAC_add_prom_wr_dl2;

    // Write data from CPU to prom
    always @(posedge Clk or posedge Reset) begin
        if (Reset) begin
            MAC_add_prom_wr_dl1 <= 0;
            MAC_add_prom_wr_dl2 <= 0;
        end else begin
            MAC_add_prom_wr_dl1 <= MAC_add_prom_wr;
            MAC_add_prom_wr_dl2 <= MAC_add_prom_wr_dl1;
        end
    end
    assign #2 wr_en = MAC_add_prom_wr_dl1 & !MAC_add_prom_wr_dl2;
    assign #2 add_wr = MAC_add_prom_add;
    assign #2 din = MAC_add_prom_data;

    // Read data from CPU to prom
    always @(posedge Clk or posedge Reset) begin
        if (Reset) begin
            add_rd <= 0;
        end else if (MAC_tx_addr_init) begin
            add_rd <= 0;
        end else if (MAC_tx_addr_rd) begin
            add_rd <= add_rd + 1;
        end
    end
    assign MAC_tx_addr_data = dout;

    // Dual port RAM
    reg [7:0] ram [0:7];
    always @(posedge Clk) begin
        if (wr_en) begin
            ram[add_wr] <= din;
        end
        dout <= ram[add_rd];            // This can now assign to dout since it's a reg
    end

endmodule