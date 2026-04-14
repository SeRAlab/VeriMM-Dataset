module wb_flash(
    clk_i, nrst_i, wb_adr_i, wb_dat_o, wb_dat_i, wb_sel_i, wb_we_i,
    wb_stb_i, wb_cyc_i, wb_ack_o,
    flash_adr_o, flash_dat_o, flash_dat_i,
    flash_oe, flash_ce, flash_we
);
    parameter aw = 19;   
    parameter dw = 32;   
    parameter ws = 4'hf; 
    input   clk_i;
    input   nrst_i;
    input   [aw-1:0] wb_adr_i;
    output  [dw-1:0] wb_dat_o;
    input   [dw-1:0] wb_dat_i;
    input   [3:0] wb_sel_i;
    input   wb_we_i;
    input   wb_stb_i;
    input   wb_cyc_i;
    output reg wb_ack_o;
    output  [18:0] flash_adr_o;
    output  [7:0] flash_dat_o;
    input   [7:0] flash_dat_i;
    output  flash_oe;
    output  flash_ce;
    output  flash_we;
    reg [3:0] waitstate;
    wire    [1:0] adr_low;
    wire wb_acc = wb_cyc_i & wb_stb_i;    
    wire wb_wr  = wb_acc & wb_we_i;       
    wire wb_rd  = wb_acc & !wb_we_i;      
    always @(posedge clk_i or negedge nrst_i)
        if(~nrst_i)
        begin
            waitstate <= 4'b0;
                wb_ack_o <= 1'b0;
        end
        else begin
                if(waitstate == 4'b0) begin
                    wb_ack_o <= 1'b0;
                    if(wb_acc) begin
                        waitstate <= waitstate + 1;
                    end
                end
                else begin
                    waitstate <= waitstate + 1;
                    if(waitstate == ws)
                        wb_ack_o <= 1'b1;
                end
         end
    assign flash_ce = !wb_acc;
    assign flash_we = !wb_wr;
    assign flash_oe = !wb_rd;
    assign adr_low = wb_sel_i == 4'b0001 ? 2'b00 : wb_sel_i == 4'b0010 ? 2'b01 : wb_sel_i == 4'b0100 ? 2'b10 : 2'b11;
    assign flash_adr_o = {wb_adr_i[18:2], adr_low};
    assign flash_dat_o = wb_sel_i == 4'b0001 ? wb_dat_i[7:0] : wb_sel_i == 4'b0010 ? wb_dat_i[15:8] : wb_sel_i == 4'b0100 ? wb_dat_i[23:16] : wb_dat_i[31:24];
    assign wb_dat_o = {flash_dat_i, flash_dat_i, flash_dat_i, flash_dat_i};
endmodule