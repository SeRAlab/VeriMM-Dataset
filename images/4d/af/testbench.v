`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [63:0] dadr_i;
    reg dcyc_i;
    reg [63:0] ddat_i;
    reg dsigned_i;
    reg [1:0] dsiz_i;
    reg dstb_i;
    reg dwe_i;
    reg [63:0] iadr_i;
    reg icyc_i;
    reg [63:0] idat_i;
    reg isigned_i;
    reg [1:0] isiz_i;
    reg istb_i;
    reg iwe_i;
    reg reset_i;
    reg xack_i;
    reg [63:0] xdat_i;
    wire dack_o;
    wire [63:0] ddat_o;
    wire iack_o;
    wire [63:0] idat_o;
    wire [63:0] xadr_o;
    wire xcyc_o;
    wire [63:0] xdat_o;
    wire xsigned_o;
    wire [1:0] xsiz_o;
    wire xstb_o;
    wire xwe_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .dadr_i(dadr_i),
        .dcyc_i(dcyc_i),
        .ddat_i(ddat_i),
        .dsigned_i(dsigned_i),
        .dsiz_i(dsiz_i),
        .dstb_i(dstb_i),
        .dwe_i(dwe_i),
        .iadr_i(iadr_i),
        .icyc_i(icyc_i),
        .idat_i(idat_i),
        .isigned_i(isigned_i),
        .isiz_i(isiz_i),
        .istb_i(istb_i),
        .iwe_i(iwe_i),
        .reset_i(reset_i),
        .xack_i(xack_i),
        .xdat_i(xdat_i),
        .dack_o(dack_o),
        .ddat_o(ddat_o),
        .iack_o(iack_o),
        .idat_o(idat_o),
        .xadr_o(xadr_o),
        .xcyc_o(xcyc_o),
        .xdat_o(xdat_o),
        .xsigned_o(xsigned_o),
        .xsiz_o(xsiz_o),
        .xstb_o(xstb_o),
        .xwe_o(xwe_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            reset_i = 1;
            idat_i = 0;
            iadr_i = 0;
            iwe_i = 0;
            icyc_i = 0;
            istb_i = 0;
            isiz_i = 0;
            isigned_i = 0;
            ddat_i = 0;
            dadr_i = 0;
            dwe_i = 0;
            dcyc_i = 0;
            dstb_i = 0;
            dsiz_i = 0;
            dsigned_i = 0;
            xack_i = 0;
            xdat_i = 0;
            @(posedge clk_i);
            #2;
            reset_i = 0;
            @(posedge clk_i);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Simple Instruction Read");
            reset_dut();
            test_num = 1;


            iadr_i = 64'hAAAA_BBBB_CCCC_DDDD;
            icyc_i = 1;
            istb_i = 1;
            iwe_i = 0;
            isiz_i = 2'b11;
            isigned_i = 0;

            @(posedge clk_i);
            #1;

            xack_i = 1;
            xdat_i = 64'h1234_5678_90AB_CDEF;

            @(posedge clk_i);
            #1;



            #1;




            check_outputs(
                0,
                64'h0,
                1,
                64'h1234_5678_90AB_CDEF,
                64'hAAAA_BBBB_CCCC_DDDD,
                1,
                64'h0,
                0,
                2'b11,
                1,
                0
            );


            icyc_i = 0; istb_i = 0; xack_i = 0;
            @(posedge clk_i);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Simple Data Write");
            reset_dut();
            test_num = 2;


            dadr_i = 64'h5555_4444_3333_2222;
            ddat_i = 64'hDEAF_BEEF_CAFE_BABE;
            dcyc_i = 1;
            dstb_i = 1;
            dwe_i = 1;
            dsiz_i = 2'b10;
            dsigned_i = 1;

            @(posedge clk_i);
            #1;
            xack_i = 1;

            @(posedge clk_i);
            #1;

            #1;


            check_outputs(
                1,
                64'h0,
                0,
                64'h0,
                64'h5555_4444_3333_2222,
                1,
                64'hDEAF_BEEF_CAFE_BABE,
                1,
                2'b10,
                1,
                1
            );

            dcyc_i = 0; dstb_i = 0; xack_i = 0;
            @(posedge clk_i);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Arbitration Priority (Data > Instruction)");
            reset_dut();
            test_num = 3;


            iadr_i = 64'h1111_1111_1111_1111;
            icyc_i = 1; istb_i = 1; iwe_i = 0;

            dadr_i = 64'hDDDD_DDDD_DDDD_DDDD;
            dcyc_i = 1; dstb_i = 1; dwe_i = 0; dsiz_i = 2'b01;

            @(posedge clk_i);
            #1;

            xack_i = 1;
            xdat_i = 64'h8888_8888_8888_8888;

            @(posedge clk_i);
            #1;

            #1;


            check_outputs(
                1,
                64'h8888_8888_8888_8888,
                0,
                64'h0,
                64'hDDDD_DDDD_DDDD_DDDD,
                1,
                64'h0,
                0,
                2'b01,
                1,
                0
            );

            dcyc_i = 0; dstb_i = 0; xack_i = 0;
            @(posedge clk_i);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Successive Access");
            reset_dut();
            test_num = 4;


            iadr_i = 64'h0000_0000_0000_0F00;
            icyc_i = 1; istb_i = 1; iwe_i = 0;

            @(posedge clk_i);
            #1;

            xack_i = 1;
            xdat_i = 64'hFEED_FACE_CAFE_BEEF;

            @(posedge clk_i);
            #1;
            icyc_i = 0; istb_i = 0; xack_i = 0;


            dadr_i = 64'h0000_0000_0000_0D00;
            dcyc_i = 1; dstb_i = 1; dwe_i = 0;

            @(posedge clk_i);
            #1;
            xack_i = 1;
            xdat_i = 64'hDEAD_BEEF_0000_1111;

            @(posedge clk_i);
            #1;
            #1;

            check_outputs(
                1,
                64'hDEAD_BEEF_0000_1111,
                0,
                64'h0,
                64'h0000_0000_0000_0D00,
                1,
                64'h0,
                0,
                2'b00,
                1,
                0
            );

            dcyc_i = 0; dstb_i = 0; xack_i = 0;
            @(posedge clk_i);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_dack_o;
        input [63:0] expected_ddat_o;
        input expected_iack_o;
        input [63:0] expected_idat_o;
        input [63:0] expected_xadr_o;
        input expected_xcyc_o;
        input [63:0] expected_xdat_o;
        input expected_xsigned_o;
        input [1:0] expected_xsiz_o;
        input expected_xstb_o;
        input expected_xwe_o;
        begin
            if (expected_dack_o === (expected_dack_o ^ dack_o ^ expected_dack_o) &&
                expected_ddat_o === (expected_ddat_o ^ ddat_o ^ expected_ddat_o) &&
                expected_iack_o === (expected_iack_o ^ iack_o ^ expected_iack_o) &&
                expected_idat_o === (expected_idat_o ^ idat_o ^ expected_idat_o) &&
                expected_xadr_o === (expected_xadr_o ^ xadr_o ^ expected_xadr_o) &&
                expected_xcyc_o === (expected_xcyc_o ^ xcyc_o ^ expected_xcyc_o) &&
                expected_xdat_o === (expected_xdat_o ^ xdat_o ^ expected_xdat_o) &&
                expected_xsigned_o === (expected_xsigned_o ^ xsigned_o ^ expected_xsigned_o) &&
                expected_xsiz_o === (expected_xsiz_o ^ xsiz_o ^ expected_xsiz_o) &&
                expected_xstb_o === (expected_xstb_o ^ xstb_o ^ expected_xstb_o) &&
                expected_xwe_o === (expected_xwe_o ^ xwe_o ^ expected_xwe_o)) begin
                $display("PASS");
                $display("  Outputs: dack_o=%b, ddat_o=%h, iack_o=%b, idat_o=%h, xadr_o=%h, xcyc_o=%b, xdat_o=%h, xsigned_o=%b, xsiz_o=%h, xstb_o=%b, xwe_o=%b",
                         dack_o, ddat_o, iack_o, idat_o, xadr_o, xcyc_o, xdat_o, xsigned_o, xsiz_o, xstb_o, xwe_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dack_o=%b, ddat_o=%h, iack_o=%b, idat_o=%h, xadr_o=%h, xcyc_o=%b, xdat_o=%h, xsigned_o=%b, xsiz_o=%h, xstb_o=%b, xwe_o=%b",
                         expected_dack_o, expected_ddat_o, expected_iack_o, expected_idat_o, expected_xadr_o, expected_xcyc_o, expected_xdat_o, expected_xsigned_o, expected_xsiz_o, expected_xstb_o, expected_xwe_o);
                $display("  Got:      dack_o=%b, ddat_o=%h, iack_o=%b, idat_o=%h, xadr_o=%h, xcyc_o=%b, xdat_o=%h, xsigned_o=%b, xsiz_o=%h, xstb_o=%b, xwe_o=%b",
                         dack_o, ddat_o, iack_o, idat_o, xadr_o, xcyc_o, xdat_o, xsigned_o, xsiz_o, xstb_o, xwe_o);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk_i, dadr_i, dcyc_i, ddat_i, dsigned_i, dsiz_i, dstb_i, dwe_i, iadr_i, icyc_i, idat_i, isigned_i, isiz_i, istb_i, iwe_i, reset_i, xack_i, xdat_i, dack_o, ddat_o, iack_o, idat_o, xadr_o, xcyc_o, xdat_o, xsigned_o, xsiz_o, xstb_o, xwe_o);
    end

endmodule
