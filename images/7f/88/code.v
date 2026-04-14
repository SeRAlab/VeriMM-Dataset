module reg_file(
   input                clk,
   input                rst_n,
   input                we,
   input      [2:0]     waddr,
   input      [31:0]    wdata,
   input      [2:0]     raddr1,
   input      [2:0]     raddr2,

   output     [31:0]    rdata1,
   output     [31:0]    rdata2
);
    reg [31:0] reg_array [7:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_array[0] <= 32'd0;
            reg_array[1] <= 32'd0;
            reg_array[2] <= 32'd0;
            reg_array[3] <= 32'd0;
            reg_array[4] <= 32'd0;
            reg_array[5] <= 32'd0;
            reg_array[6] <= 32'd0;
            reg_array[7] <= 32'd0;
        end
        else if (we) reg_array[waddr] <= wdata;
    end

    assign rdata1 = reg_array[raddr1];
    assign rdata2 = reg_array[raddr2];
endmodule