`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] iEXCEPT_ADDR;
    reg [31:0] iEXCEPT_DATA;
    reg [1:0] iEXCEPT_MMUMOD;
    reg [1:0] iEXCEPT_ORDER;
    reg [31:0] iEXCEPT_PDT;
    reg iEXCEPT_REQ;
    reg iEXCEPT_RW;
    reg [13:0] iEXCEPT_TID;
    reg [31:0] iEXE_ADDR;
    reg [31:0] iEXE_DATA;
    reg [3:0] iEXE_MASK;
    reg [1:0] iEXE_MMUMOD;
    reg [1:0] iEXE_ORDER;
    reg [31:0] iEXE_PDT;
    reg iEXE_REQ;
    reg iEXE_RW;
    reg [13:0] iEXE_TID;
    reg iLDST_BUSY;
    reg [31:0] iLDST_DATA;
    reg [13:0] iLDST_MMU_FLAGS;
    reg iLDST_PAGEFAULT;
    reg iLDST_VALID;
    reg iUSE_SEL;
    wire oEXCEPT_BUSY;
    wire [31:0] oEXCEPT_DATA;
    wire oEXCEPT_REQ;
    wire oEXE_BUSY;
    wire [31:0] oEXE_DATA;
    wire [13:0] oEXE_MMU_FLAGS;
    wire oEXE_PAGEFAULT;
    wire oEXE_REQ;
    wire [31:0] oLDST_ADDR;
    wire [31:0] oLDST_DATA;
    wire [3:0] oLDST_MASK;
    wire [1:0] oLDST_MMUMOD;
    wire [1:0] oLDST_ORDER;
    wire [31:0] oLDST_PDT;
    wire oLDST_REQ;
    wire oLDST_RW;
    wire [13:0] oLDST_TID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iEXCEPT_ADDR(iEXCEPT_ADDR),
        .iEXCEPT_DATA(iEXCEPT_DATA),
        .iEXCEPT_MMUMOD(iEXCEPT_MMUMOD),
        .iEXCEPT_ORDER(iEXCEPT_ORDER),
        .iEXCEPT_PDT(iEXCEPT_PDT),
        .iEXCEPT_REQ(iEXCEPT_REQ),
        .iEXCEPT_RW(iEXCEPT_RW),
        .iEXCEPT_TID(iEXCEPT_TID),
        .iEXE_ADDR(iEXE_ADDR),
        .iEXE_DATA(iEXE_DATA),
        .iEXE_MASK(iEXE_MASK),
        .iEXE_MMUMOD(iEXE_MMUMOD),
        .iEXE_ORDER(iEXE_ORDER),
        .iEXE_PDT(iEXE_PDT),
        .iEXE_REQ(iEXE_REQ),
        .iEXE_RW(iEXE_RW),
        .iEXE_TID(iEXE_TID),
        .iLDST_BUSY(iLDST_BUSY),
        .iLDST_DATA(iLDST_DATA),
        .iLDST_MMU_FLAGS(iLDST_MMU_FLAGS),
        .iLDST_PAGEFAULT(iLDST_PAGEFAULT),
        .iLDST_VALID(iLDST_VALID),
        .iUSE_SEL(iUSE_SEL),
        .oEXCEPT_BUSY(oEXCEPT_BUSY),
        .oEXCEPT_DATA(oEXCEPT_DATA),
        .oEXCEPT_REQ(oEXCEPT_REQ),
        .oEXE_BUSY(oEXE_BUSY),
        .oEXE_DATA(oEXE_DATA),
        .oEXE_MMU_FLAGS(oEXE_MMU_FLAGS),
        .oEXE_PAGEFAULT(oEXE_PAGEFAULT),
        .oEXE_REQ(oEXE_REQ),
        .oLDST_ADDR(oLDST_ADDR),
        .oLDST_DATA(oLDST_DATA),
        .oLDST_MASK(oLDST_MASK),
        .oLDST_MMUMOD(oLDST_MMUMOD),
        .oLDST_ORDER(oLDST_ORDER),
        .oLDST_PDT(oLDST_PDT),
        .oLDST_REQ(oLDST_REQ),
        .oLDST_RW(oLDST_RW),
        .oLDST_TID(oLDST_TID)
    );
    task reset_inputs;

        begin
            iEXCEPT_ADDR = 0; iEXCEPT_DATA = 0; iEXCEPT_MMUMOD = 0;
            iEXCEPT_ORDER = 0; iEXCEPT_PDT = 0; iEXCEPT_REQ = 0;
            iEXCEPT_RW = 0; iEXCEPT_TID = 0; iEXE_ADDR = 0;
            iEXE_DATA = 0; iEXE_MASK = 0; iEXE_MMUMOD = 0;
            iEXE_ORDER = 0; iEXE_PDT = 0; iEXE_REQ = 0;
            iEXE_RW = 0; iEXE_TID = 0; iLDST_BUSY = 0;
            iLDST_DATA = 0; iLDST_MMU_FLAGS = 0; iLDST_PAGEFAULT = 0;
            iLDST_VALID = 0; iUSE_SEL = 0;
            #5;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Standard Execution Request (iUSE_SEL=0)");
            reset_inputs();
            iUSE_SEL = 0;
            iEXE_REQ = 1;
            iEXE_ADDR = 32'hA0001234;
            iEXE_DATA = 32'hDEADBEEF;
            iEXE_MASK = 4'b1111;
            iEXE_RW   = 1;
            iEXE_TID  = 14'h00A5;
            iEXE_ORDER = 2'b10;
            iEXE_MMUMOD = 2'b01;
            iEXE_PDT  = 32'hB0000000;
            iLDST_BUSY = 0;



            #1;




            check_outputs(1'b1, 32'h0, 1'b0, 1'b0, 32'h0, 14'h0, 1'b0, 1'b0,
                          32'hA0001234, 32'hDEADBEEF, 4'b1111, 2'b01, 2'b10, 32'hB0000000,
                          1'b1, 1'b1, 14'h00A5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Exception Handling Request (iUSE_SEL=1)");
            reset_inputs();
            iUSE_SEL = 1;
            iEXCEPT_REQ = 1;
            iEXCEPT_ADDR = 32'hFFFF0000;
            iEXCEPT_DATA = 32'hCAFEBABE;
            iEXCEPT_RW   = 0;
            iEXCEPT_TID  = 14'h3FFF;
            iEXCEPT_ORDER = 2'b00;
            iEXCEPT_MMUMOD = 2'b11;
            iEXCEPT_PDT  = 32'hC0000000;
            iLDST_BUSY = 1;



            #1;




            check_outputs(1'b1, 32'h0, 1'b0, 1'b1, 32'h0, 14'h0, 1'b0, 1'b0,
                          32'hFFFF0000, 32'hCAFEBABE, 4'hf, 2'b11, 2'b00, 32'hC0000000,
                          1'b1, 1'b0, 14'h3FFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Memory Return Path - Execution Data (iUSE_SEL=0)");
            reset_inputs();
            iUSE_SEL = 0;
            iLDST_VALID = 1;
            iLDST_DATA = 32'h12345678;
            iLDST_PAGEFAULT = 0;
            iLDST_MMU_FLAGS = 14'h1FFF;


            #1;



            check_outputs(1'b1, 32'h0, 1'b0, 1'b0, 32'h12345678, 14'h1FFF, 1'b0, 1'b1,
                          32'h0, 32'h0, 4'h0, 2'b0, 2'b0, 32'h0,
                          1'b0, 1'b0, 14'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Memory Return Path - Exception Data (iUSE_SEL=1)");
            reset_inputs();
            iUSE_SEL = 1;
            iLDST_VALID = 1;
            iLDST_DATA = 32'h87654321;


            #1;



            check_outputs(1'b0, 32'h87654321, 1'b1, 1'b1, 32'h0, 14'h0, 1'b0, 1'b0,
                          32'h0, 32'h0, 4'h0, 2'b0, 2'b0, 32'h0,
                          1'b0, 1'b0, 14'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Page Fault Handling (iUSE_SEL=0)");
            reset_inputs();
            iUSE_SEL = 0;
            iLDST_VALID = 1;
            iLDST_PAGEFAULT = 1;
            iLDST_MMU_FLAGS = 14'h0001;
            iLDST_DATA = 32'hBAD00BAD;


            #1;



            check_outputs(1'b1, 32'h0, 1'b0, 1'b0, 32'hBAD00BAD, 14'h0001, 1'b1, 1'b1,
                          32'h0, 32'h0, 4'h0, 2'b0, 2'b0, 32'h0,
                          1'b0, 1'b0, 14'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Arbitration Priority Check");
            reset_inputs();

            iUSE_SEL = 1;
            iEXE_REQ = 1; iEXE_ADDR = 32'hEEEEEEEE;
            iEXCEPT_REQ = 1; iEXCEPT_ADDR = 32'hCCCCCCCC;
            iLDST_BUSY = 0;

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 1'b1, 32'h0, 14'h0, 1'b0, 1'b0,
                          32'hCCCCCCCC, 32'h0, 4'hf, 2'b0, 2'b0, 32'h0,
                          1'b1, 1'b0, 14'h0);
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
        testcase006();
        
        
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
        input expected_oEXCEPT_BUSY;
        input [31:0] expected_oEXCEPT_DATA;
        input expected_oEXCEPT_REQ;
        input expected_oEXE_BUSY;
        input [31:0] expected_oEXE_DATA;
        input [13:0] expected_oEXE_MMU_FLAGS;
        input expected_oEXE_PAGEFAULT;
        input expected_oEXE_REQ;
        input [31:0] expected_oLDST_ADDR;
        input [31:0] expected_oLDST_DATA;
        input [3:0] expected_oLDST_MASK;
        input [1:0] expected_oLDST_MMUMOD;
        input [1:0] expected_oLDST_ORDER;
        input [31:0] expected_oLDST_PDT;
        input expected_oLDST_REQ;
        input expected_oLDST_RW;
        input [13:0] expected_oLDST_TID;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oEXCEPT_BUSY === (expected_oEXCEPT_BUSY ^ oEXCEPT_BUSY ^ expected_oEXCEPT_BUSY) &&
                expected_oEXCEPT_DATA === (expected_oEXCEPT_DATA ^ oEXCEPT_DATA ^ expected_oEXCEPT_DATA) &&
                expected_oEXCEPT_REQ === (expected_oEXCEPT_REQ ^ oEXCEPT_REQ ^ expected_oEXCEPT_REQ) &&
                expected_oEXE_BUSY === (expected_oEXE_BUSY ^ oEXE_BUSY ^ expected_oEXE_BUSY) &&
                expected_oEXE_DATA === (expected_oEXE_DATA ^ oEXE_DATA ^ expected_oEXE_DATA) &&
                expected_oEXE_MMU_FLAGS === (expected_oEXE_MMU_FLAGS ^ oEXE_MMU_FLAGS ^ expected_oEXE_MMU_FLAGS) &&
                expected_oEXE_PAGEFAULT === (expected_oEXE_PAGEFAULT ^ oEXE_PAGEFAULT ^ expected_oEXE_PAGEFAULT) &&
                expected_oEXE_REQ === (expected_oEXE_REQ ^ oEXE_REQ ^ expected_oEXE_REQ) &&
                expected_oLDST_ADDR === (expected_oLDST_ADDR ^ oLDST_ADDR ^ expected_oLDST_ADDR) &&
                expected_oLDST_DATA === (expected_oLDST_DATA ^ oLDST_DATA ^ expected_oLDST_DATA) &&
                expected_oLDST_MASK === (expected_oLDST_MASK ^ oLDST_MASK ^ expected_oLDST_MASK) &&
                expected_oLDST_MMUMOD === (expected_oLDST_MMUMOD ^ oLDST_MMUMOD ^ expected_oLDST_MMUMOD) &&
                expected_oLDST_ORDER === (expected_oLDST_ORDER ^ oLDST_ORDER ^ expected_oLDST_ORDER) &&
                expected_oLDST_PDT === (expected_oLDST_PDT ^ oLDST_PDT ^ expected_oLDST_PDT) &&
                expected_oLDST_REQ === (expected_oLDST_REQ ^ oLDST_REQ ^ expected_oLDST_REQ) &&
                expected_oLDST_RW === (expected_oLDST_RW ^ oLDST_RW ^ expected_oLDST_RW) &&
                expected_oLDST_TID === (expected_oLDST_TID ^ oLDST_TID ^ expected_oLDST_TID)) begin
                $display("PASS");
                $display("  Outputs: oEXCEPT_BUSY=%b, oEXCEPT_DATA=%h, oEXCEPT_REQ=%b, oEXE_BUSY=%b, oEXE_DATA=%h, oEXE_MMU_FLAGS=%h, oEXE_PAGEFAULT=%b, oEXE_REQ=%b, oLDST_ADDR=%h, oLDST_DATA=%h, oLDST_MASK=%h, oLDST_MMUMOD=%h, oLDST_ORDER=%h, oLDST_PDT=%h, oLDST_REQ=%b, oLDST_RW=%b, oLDST_TID=%h",
                         oEXCEPT_BUSY, oEXCEPT_DATA, oEXCEPT_REQ, oEXE_BUSY, oEXE_DATA, oEXE_MMU_FLAGS, oEXE_PAGEFAULT, oEXE_REQ, oLDST_ADDR, oLDST_DATA, oLDST_MASK, oLDST_MMUMOD, oLDST_ORDER, oLDST_PDT, oLDST_REQ, oLDST_RW, oLDST_TID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oEXCEPT_BUSY=%b, oEXCEPT_DATA=%h, oEXCEPT_REQ=%b, oEXE_BUSY=%b, oEXE_DATA=%h, oEXE_MMU_FLAGS=%h, oEXE_PAGEFAULT=%b, oEXE_REQ=%b, oLDST_ADDR=%h, oLDST_DATA=%h, oLDST_MASK=%h, oLDST_MMUMOD=%h, oLDST_ORDER=%h, oLDST_PDT=%h, oLDST_REQ=%b, oLDST_RW=%b, oLDST_TID=%h",
                         expected_oEXCEPT_BUSY, expected_oEXCEPT_DATA, expected_oEXCEPT_REQ, expected_oEXE_BUSY, expected_oEXE_DATA, expected_oEXE_MMU_FLAGS, expected_oEXE_PAGEFAULT, expected_oEXE_REQ, expected_oLDST_ADDR, expected_oLDST_DATA, expected_oLDST_MASK, expected_oLDST_MMUMOD, expected_oLDST_ORDER, expected_oLDST_PDT, expected_oLDST_REQ, expected_oLDST_RW, expected_oLDST_TID);
                $display("  Got:      oEXCEPT_BUSY=%b, oEXCEPT_DATA=%h, oEXCEPT_REQ=%b, oEXE_BUSY=%b, oEXE_DATA=%h, oEXE_MMU_FLAGS=%h, oEXE_PAGEFAULT=%b, oEXE_REQ=%b, oLDST_ADDR=%h, oLDST_DATA=%h, oLDST_MASK=%h, oLDST_MMUMOD=%h, oLDST_ORDER=%h, oLDST_PDT=%h, oLDST_REQ=%b, oLDST_RW=%b, oLDST_TID=%h",
                         oEXCEPT_BUSY, oEXCEPT_DATA, oEXCEPT_REQ, oEXE_BUSY, oEXE_DATA, oEXE_MMU_FLAGS, oEXE_PAGEFAULT, oEXE_REQ, oLDST_ADDR, oLDST_DATA, oLDST_MASK, oLDST_MMUMOD, oLDST_ORDER, oLDST_PDT, oLDST_REQ, oLDST_RW, oLDST_TID);
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

endmodule
