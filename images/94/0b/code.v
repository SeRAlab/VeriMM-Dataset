module top_module(
    input clk,
    input reset,
    output reg [3:0] output1,
    output reg [3:0] output2
);// Commenting out the instance of the missing module to fix compilation error
    // wire VPWR;
    // wire VGND;
    // sky130_fd_sc_hs__tapvgnd my_tapvgnd (
    //     .VPWR(VPWR),
    //     .VGND(VGND)
    // );

    integer count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

    always @(*) begin
        output1 = count;
        output2 = ~count;
    end

endmodule