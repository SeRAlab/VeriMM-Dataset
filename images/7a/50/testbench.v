`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg [9:0] iDATA;
    reg iEND;
    reg iFVAL;
    reg iLVAL;
    reg iRST;
    reg iSTART;
    wire [9:0] oDATA;
    wire oDVAL;
    wire oError;
    wire [31:0] oFrame_Cont;
    wire [9:0] oX_Cont;
    wire [9:0] oY_Cont;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iDATA(iDATA),
        .iEND(iEND),
        .iFVAL(iFVAL),
        .iLVAL(iLVAL),
        .iRST(iRST),
        .iSTART(iSTART),
        .oDATA(oDATA),
        .oDVAL(oDVAL),
        .oError(oError),
        .oFrame_Cont(oFrame_Cont),
        .oX_Cont(oX_Cont),
        .oY_Cont(oY_Cont)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

    begin
        iRST = 1;
        iSTART = 0;
        iEND = 0;
        iFVAL = 0;
        iLVAL = 0;
        iDATA = 0;
        repeat(5) @(posedge iCLK);
        iRST = 0;
        repeat(2) @(posedge iCLK);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Basic Frame (Single Line)...");
        reset_dut();


        iSTART = 1;
        @(posedge iCLK);
        iSTART = 0;


        iFVAL = 1;
        @(posedge iCLK);


        iLVAL = 1;
        iDATA = 10'h100; @(posedge iCLK);
        iDATA = 10'h101; @(posedge iCLK);
        iDATA = 10'h102; @(posedge iCLK);
        iDATA = 10'h103; @(posedge iCLK);
        iDATA = 10'h104; @(posedge iCLK);

        iLVAL = 0;
        repeat(2) @(posedge iCLK);
        iFVAL = 0;
        repeat(5) @(posedge iCLK);


        #1;



        check_outputs(10'h104, 0, 0, 32'd1, 10'd5, 10'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Multi-line Frame...");
        reset_dut();

        iSTART = 1;
        @(posedge iCLK); iSTART = 0;

        iFVAL = 1;

        @(posedge iCLK); iLVAL = 1;
        iDATA = 10'h0A1; repeat(3) @(posedge iCLK);
        iLVAL = 0;
        repeat(3) @(posedge iCLK);


        iLVAL = 1;
        iDATA = 10'h0B1; repeat(3) @(posedge iCLK);
        iLVAL = 0;
        repeat(2) @(posedge iCLK);

        iFVAL = 0;
        repeat(5) @(posedge iCLK);


        #1;



        check_outputs(10'h0B1, 0, 0, 32'd1, 10'd3, 10'd1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Multi-frame counting...");
        reset_dut();

        iSTART = 1;
        @(posedge iCLK); iSTART = 0;


        iFVAL = 1; @(posedge iCLK);
        iLVAL = 1; iDATA = 10'h1; @(posedge iCLK); iLVAL = 0;
        @(posedge iCLK); iFVAL = 0;
        repeat(5) @(posedge iCLK);


        iFVAL = 1; @(posedge iCLK);
        iLVAL = 1; iDATA = 10'h2; @(posedge iCLK); iLVAL = 0;
        @(posedge iCLK); iFVAL = 0;
        repeat(5) @(posedge iCLK);

        #1;


        check_outputs(10'h2, 0, 0, 32'd2, 10'd1, 10'd0);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Stop Signal Logic...");
        reset_dut();

        iSTART = 1;
        @(posedge iCLK); iSTART = 0;


        iFVAL = 1; iLVAL = 1; iDATA = 10'hAAA;
        repeat(2) @(posedge iCLK);


        iEND = 1;
        @(posedge iCLK); iEND = 0;
        iFVAL = 0; iLVAL = 0;

        repeat(10) @(posedge iCLK);


        iFVAL = 1; iLVAL = 1; iDATA = 10'h555;
        repeat(2) @(posedge iCLK);
        iLVAL = 0; iFVAL = 0;



        #1;




        check_outputs(10'h555, 0, 0, 32'd0, 10'd2, 10'd0);
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
        input [9:0] expected_oDATA;
        input expected_oDVAL;
        input expected_oError;
        input [31:0] expected_oFrame_Cont;
        input [9:0] expected_oX_Cont;
        input [9:0] expected_oY_Cont;
        begin
            if (expected_oDATA === (expected_oDATA ^ oDATA ^ expected_oDATA) &&
                expected_oDVAL === (expected_oDVAL ^ oDVAL ^ expected_oDVAL) &&
                expected_oError === (expected_oError ^ oError ^ expected_oError) &&
                expected_oFrame_Cont === (expected_oFrame_Cont ^ oFrame_Cont ^ expected_oFrame_Cont) &&
                expected_oX_Cont === (expected_oX_Cont ^ oX_Cont ^ expected_oX_Cont) &&
                expected_oY_Cont === (expected_oY_Cont ^ oY_Cont ^ expected_oY_Cont)) begin
                $display("PASS");
                $display("  Outputs: oDATA=%h, oDVAL=%b, oError=%b, oFrame_Cont=%h, oX_Cont=%h, oY_Cont=%h",
                         oDATA, oDVAL, oError, oFrame_Cont, oX_Cont, oY_Cont);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oDATA=%h, oDVAL=%b, oError=%b, oFrame_Cont=%h, oX_Cont=%h, oY_Cont=%h",
                         expected_oDATA, expected_oDVAL, expected_oError, expected_oFrame_Cont, expected_oX_Cont, expected_oY_Cont);
                $display("  Got:      oDATA=%h, oDVAL=%b, oError=%b, oFrame_Cont=%h, oX_Cont=%h, oY_Cont=%h",
                         oDATA, oDVAL, oError, oFrame_Cont, oX_Cont, oY_Cont);
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
        $dumpvars(0,iCLK, iDATA, iEND, iFVAL, iLVAL, iRST, iSTART, oDATA, oDVAL, oError, oFrame_Cont, oX_Cont, oY_Cont);
    end

endmodule
