module top_module(input exe_wb_en, mem_wb_en, en, input [3:0] src1, src2, exe_dest, mem_dest, output reg [1:0] forward1, forward2);always @(*) begin
        {forward1, forward2} = 4'b0;

        if(mem_wb_en && (src1 == mem_dest))
            forward1 = 2'd1;
        else if(exe_wb_en && (src1 == exe_dest))
            forward1 = 2'd2;

        if(mem_wb_en && (src2 == mem_dest))
            forward2 = 2'd1;
        else if(exe_wb_en && (src2 == exe_dest))
            forward2 = 2'd2;

        {forward1, forward2} = {forward1, forward2} & {4{en}};
    end
endmodule