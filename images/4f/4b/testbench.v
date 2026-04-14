`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLOCK;
    reg [31:0] iRD_ADDR;
    reg iRD_BUSY;
    reg iRD_REQ;
    reg iREMOVE;
    reg iRESET_SYNC;
    reg [31:0] iWR_ADDR;
    reg [511:0] iWR_DATA;
    reg [255:0] iWR_MMU_FLAGS;
    reg iWR_REQ;
    reg inRESET;
    wire oRD_BUSY;
    wire [63:0] oRD_DATA;
    wire oRD_HIT;
    wire [23:0] oRD_MMU_FLAGS;
    wire oRD_VALID;
    wire oWR_BUSY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLOCK(iCLOCK),
        .iRD_ADDR(iRD_ADDR),
        .iRD_BUSY(iRD_BUSY),
        .iRD_REQ(iRD_REQ),
        .iREMOVE(iREMOVE),
        .iRESET_SYNC(iRESET_SYNC),
        .iWR_ADDR(iWR_ADDR),
        .iWR_DATA(iWR_DATA),
        .iWR_MMU_FLAGS(iWR_MMU_FLAGS),
        .iWR_REQ(iWR_REQ),
        .inRESET(inRESET),
        .oRD_BUSY(oRD_BUSY),
        .oRD_DATA(oRD_DATA),
        .oRD_HIT(oRD_HIT),
        .oRD_MMU_FLAGS(oRD_MMU_FLAGS),
        .oRD_VALID(oRD_VALID),
        .oWR_BUSY(oWR_BUSY)
    );

    // Clock generation (10ns period)
    initial begin
        iCLOCK = 0;
        forever #5 iCLOCK = ~iCLOCK;
    end

        task reset_dut;

    begin
        inRESET = 0;
        iRESET_SYNC = 1;
        iREMOVE = 0;
        iRD_REQ = 0;
        iRD_ADDR = 0;
        iRD_BUSY = 0;
        iWR_REQ = 0;
        iWR_ADDR = 0;
        iWR_DATA = 0;
        iWR_MMU_FLAGS = 0;
        repeat(2) @(posedge iCLOCK);
        #1 inRESET = 1;
        iRESET_SYNC = 0;
        @(posedge iCLOCK);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        repeat(2) @(posedge iCLOCK);

        #1;


        check_outputs(1'b0, 64'h0, 1'b0, 24'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge iCLOCK);
        iRD_REQ = 1;
        iRD_ADDR = 32'h12345678;
        @(posedge iCLOCK);
        iRD_REQ = 0;
        repeat(3) @(posedge iCLOCK);
        #1;

        check_outputs(1'b0, 64'h0, 1'b0, 24'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(posedge iCLOCK);
        iWR_REQ = 1;
        iWR_ADDR = 32'hCAFEBABE;
        iWR_DATA = 512'hDEADBEEF_CAFEBABE_01234567_89ABCDEF;
        iWR_MMU_FLAGS = 256'h1;
        @(posedge iCLOCK);
        iWR_REQ = 0;
        repeat(3) @(posedge iCLOCK);
        #1;

        check_outputs(1'b0, 64'h0, 1'b0, 24'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        @(posedge iCLOCK);
        iREMOVE = 1;
        @(posedge iCLOCK);
        iREMOVE = 0;
        repeat(2) @(posedge iCLOCK);
        #1;

        check_outputs(1'b0, 64'h0, 1'b0, 24'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(posedge iCLOCK);
        iRD_REQ = 1;
        iRD_ADDR = 32'hAAAA_5555;
        iWR_REQ = 1;
        iWR_ADDR = 32'h5555_AAAA;
        iWR_DATA = 512'hFFFFFFFF_00000000_FFFFFFFF_00000000;
        @(posedge iCLOCK);
        iRD_REQ = 0;
        iWR_REQ = 0;
        repeat(5) @(posedge iCLOCK);
        #1;

        check_outputs(1'b0, 64'h0, 1'b0, 24'h0, 1'b0, 1'b0);
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
        testcase005();
        
        
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
        input expected_oRD_BUSY;
        input [63:0] expected_oRD_DATA;
        input expected_oRD_HIT;
        input [23:0] expected_oRD_MMU_FLAGS;
        input expected_oRD_VALID;
        input expected_oWR_BUSY;
        begin
            if (expected_oRD_BUSY === (expected_oRD_BUSY ^ oRD_BUSY ^ expected_oRD_BUSY) &&
                expected_oRD_DATA === (expected_oRD_DATA ^ oRD_DATA ^ expected_oRD_DATA) &&
                expected_oRD_HIT === (expected_oRD_HIT ^ oRD_HIT ^ expected_oRD_HIT) &&
                expected_oRD_MMU_FLAGS === (expected_oRD_MMU_FLAGS ^ oRD_MMU_FLAGS ^ expected_oRD_MMU_FLAGS) &&
                expected_oRD_VALID === (expected_oRD_VALID ^ oRD_VALID ^ expected_oRD_VALID) &&
                expected_oWR_BUSY === (expected_oWR_BUSY ^ oWR_BUSY ^ expected_oWR_BUSY)) begin
                $display("PASS");
                $display("  Outputs: oRD_BUSY=%b, oRD_DATA=%h, oRD_HIT=%b, oRD_MMU_FLAGS=%h, oRD_VALID=%b, oWR_BUSY=%b",
                         oRD_BUSY, oRD_DATA, oRD_HIT, oRD_MMU_FLAGS, oRD_VALID, oWR_BUSY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oRD_BUSY=%b, oRD_DATA=%h, oRD_HIT=%b, oRD_MMU_FLAGS=%h, oRD_VALID=%b, oWR_BUSY=%b",
                         expected_oRD_BUSY, expected_oRD_DATA, expected_oRD_HIT, expected_oRD_MMU_FLAGS, expected_oRD_VALID, expected_oWR_BUSY);
                $display("  Got:      oRD_BUSY=%b, oRD_DATA=%h, oRD_HIT=%b, oRD_MMU_FLAGS=%h, oRD_VALID=%b, oWR_BUSY=%b",
                         oRD_BUSY, oRD_DATA, oRD_HIT, oRD_MMU_FLAGS, oRD_VALID, oWR_BUSY);
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
        $dumpvars(0,iCLOCK, iRD_ADDR, iRD_BUSY, iRD_REQ, iREMOVE, iRESET_SYNC, iWR_ADDR, iWR_DATA, iWR_MMU_FLAGS, iWR_REQ, inRESET, oRD_BUSY, oRD_DATA, oRD_HIT, oRD_MMU_FLAGS, oRD_VALID, oWR_BUSY);
    end

endmodule
