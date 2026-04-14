module top_module(
        input [4:0] src1,
        input [4:0] src2,
        input [4:0] dest,
        input [4:0] mem_dest,
        input [4:0] write_back_dest,
        input mem_wb,
        input write_back_wb,
        input forward_enable,
        output [1:0] to_val1_mux,
        output [1:0] to_val2_mux,
        output [1:0] to_src2_mux
    );assign to_val1_mux = !forward_enable? 0:
                        (src1 != 0 && src1 == mem_dest && mem_wb)? 1:
                        (src1 != 0 && src1 == write_back_dest && write_back_wb)? 2:0;
    assign to_val2_mux = !forward_enable? 0:
                        (src2 != 0 && src2 == mem_dest && mem_wb)? 1:
                        (src2 != 0 && src2 == write_back_dest && write_back_wb)? 2:0;
    assign to_src2_mux = !forward_enable? 0:
                        (dest != 0 && dest == mem_dest && mem_wb)? 1:
                        (dest != 0 && dest == write_back_dest && write_back_wb)? 2:0;
endmodule