module bw_r_tlb_data_ram(rd_data, rw_index_vld, wr_vld_tmp, clk, cam_vld,
        rw_index, tlb_index, tlb_index_vld, rw_disable, rst_tri_en, wr_tte_data,
        rd_tte_data, cam_index, cam_hit_any, wr_vld);
        input                   rd_data;
        input                   rw_index_vld;
        input                   wr_vld_tmp;
        input                   clk;
        input   [(6 - 1):0]     rw_index;
        input   [(6 - 1):0]     tlb_index;
        input                   tlb_index_vld;
        input   [(6 - 1):0]     cam_index;
        input                   cam_hit_any;
        input                   rw_disable;
        input                   rst_tri_en;
        input                   cam_vld;
        input   [42:0]          wr_tte_data;
        input                   wr_vld;
        output  [42:0]          rd_tte_data;
        wire    [42:0]          rd_tte_data;
        reg     [42:0]          tte_data_ram[(64 - 1):0];
        wire [5:0] wr_addr = (rw_index_vld & wr_vld_tmp) ? rw_index :tlb_index;
        wire wr_en = ((rw_index_vld & wr_vld_tmp) & (~rw_disable)) |
                     (((tlb_index_vld & (~rw_index_vld)) & wr_vld_tmp) & (~rw_disable));
        always @(negedge clk) begin
          if (wr_en)
            tte_data_ram[wr_addr] <= wr_tte_data[42:0];
          end
        wire [5:0] rd_addr = rd_data ? rw_index : cam_index;
        wire rd_en = (rd_data & (~rw_disable)) | ((cam_vld & (~rw_disable)));
        reg [42:0] rd_tte_data_temp;
        always @(negedge clk) begin
	  if((cam_vld & (~rw_disable)) & (!cam_hit_any)) begin
	    rd_tte_data_temp <= 43'bx;
	  end else
          if (rd_en) begin
            rd_tte_data_temp[42:0] <= tte_data_ram[rd_addr];
          end
	end
reg rdwe;
reg [42:0] wr_tte_data_d;
       always @(negedge clk) begin
	 wr_tte_data_d <= wr_tte_data;
       end
       always @(negedge clk) begin
         if(wr_en) rdwe <= 1'b1;
         else if(rd_en) rdwe <= 1'b0;
       end
       assign rd_tte_data = rdwe ? wr_tte_data_d : rd_tte_data_temp;
endmodule