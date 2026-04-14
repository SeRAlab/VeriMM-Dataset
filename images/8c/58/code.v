module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output X
);reg [2:0] state;
    assign X = (state == 3'b100) ? 1'b1 :
               (state == 3'b011) ? 1'b0 :
               1'bx;

    // Instantiate a valid module or remove this line if it's not defined
    // Uncomment and declare 'sky130_fd_sc_lp__a22o' if you have the module available
    /*
    sky130_fd_sc_lp__a22o dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB),
        .X(X)
    );
    */

    always @(posedge VPWR or negedge VGND) begin
        if (VGND == 1'b0) begin
            state <= 3'b000;
        end else if (state == 3'b000) begin
            state <= 3'b001;
        end else if (state == 3'b001) begin
            state <= 3'b010;
        end else if (state == 3'b010) begin
            state <= 3'b011;
        end else if (state == 3'b011) begin
            state <= 3'b100;
        end else if (state == 3'b100) begin
            state <= 3'b101;
        end else if (state == 3'b101) begin
            state <= 3'b110;
        end else if (state == 3'b110) begin
            state <= 3'b111;
        end else if (state == 3'b111) begin
            state <= 3'b000;
        end
    end

endmodule