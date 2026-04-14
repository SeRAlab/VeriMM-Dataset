`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] ADDR_LOAD;
    reg CK;
    reg CLEARING;
    reg [3:0] COLOR_INDEX;
    reg LOAD;
    reg PCK2;
    reg [7:0] SPR_PAL;
    reg WE;
    wire [11:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR_LOAD(ADDR_LOAD),
        .CK(CK),
        .CLEARING(CLEARING),
        .COLOR_INDEX(COLOR_INDEX),
        .LOAD(LOAD),
        .PCK2(PCK2),
        .SPR_PAL(SPR_PAL),
        .WE(WE),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CK = 0;
        forever #5 CK = ~CK;
    end

        task reset_dut;

        begin
            ADDR_LOAD = 0;
            CLEARING = 1;
            COLOR_INDEX = 0;
            LOAD = 0;
            SPR_PAL = 0;
            WE = 0;
            @(posedge CK);
            #1;
            CLEARING = 0;
            @(posedge CK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Test Case 001: Write and Read at Address 0");
            reset_dut();


            ADDR_LOAD = 8'h00;
            LOAD = 1;
            @(posedge CK);
            #1;
            LOAD = 0;


            WE = 1;
            COLOR_INDEX = 4'hA;
            SPR_PAL = 8'h55;
            @(posedge CK);
            #1;
            WE = 0;


            ADDR_LOAD = 8'h00;
            LOAD = 1;
            @(posedge CK);
            #1;
            LOAD = 0;
            @(posedge CK);
            #1;

            #1;


            check_outputs(12'hA55);
        end
        endtask

    task testcase002;

        begin
            $display("Running Test Case 002: Write to Address 0xFF");
            reset_dut();


            ADDR_LOAD = 8'hFF;
            LOAD = 1;
            @(posedge CK);
            #1;
            LOAD = 0;


            WE = 1;
            COLOR_INDEX = 4'hF;
            SPR_PAL = 8'hAA;
            @(posedge CK);
            #1;
            WE = 0;


            ADDR_LOAD = 8'hFF;
            LOAD = 1;
            @(posedge CK);
            #1;
            LOAD = 0;
            @(posedge CK);
            #1;

            #1;


            check_outputs(12'hFAA);
        end
        endtask

    task testcase003;

        begin
            $display("Running Test Case 003: Sequential Write Check");
            reset_dut();


            ADDR_LOAD = 8'h10;
            LOAD = 1;
            @(posedge CK);
            #1;
            LOAD = 0;


            WE = 1; COLOR_INDEX = 4'h1; SPR_PAL = 8'h11;
            @(posedge CK); #1;


            COLOR_INDEX = 4'h2; SPR_PAL = 8'h22;
            @(posedge CK); #1;
            WE = 0;


            ADDR_LOAD = 8'h11;
            LOAD = 1;
            @(posedge CK); #1;
            LOAD = 0;
            @(posedge CK); #1;

            #1;


            check_outputs(12'h222);
        end
        endtask

    task testcase004;

        begin
            $display("Running Test Case 004: Clearing Signal Test");
            reset_dut();


            ADDR_LOAD = 8'h20;
            LOAD = 1;
            @(posedge CK); #1;
            LOAD = 0;
            WE = 1; COLOR_INDEX = 4'hB; SPR_PAL = 8'hBB;
            @(posedge CK); #1;
            WE = 0;


            CLEARING = 1;
            @(posedge CK); #1;
            CLEARING = 0;


            ADDR_LOAD = 8'h20;
            LOAD = 1;
            @(posedge CK); #1;
            LOAD = 0;
            @(posedge CK); #1;

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase005;

        begin
            $display("Running Test Case 005: Load and Write with PCK2 toggling");
            reset_dut();

            ADDR_LOAD = 8'h50;
            LOAD = 1;
            @(posedge CK); #1;
            LOAD = 0;

            WE = 1; COLOR_INDEX = 4'h5; SPR_PAL = 8'h50;
            @(posedge CK); #1;
            WE = 0;


            repeat(4) @(posedge PCK2);

            ADDR_LOAD = 8'h50;
            LOAD = 1;
            @(posedge CK); #1;
            LOAD = 0;
            @(posedge CK); #1;

            #1;


            check_outputs(12'h550);
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
        input [11:0] expected_DATA_OUT;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h",
                         DATA_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h",
                         expected_DATA_OUT);
                $display("  Got:      DATA_OUT=%h",
                         DATA_OUT);
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
        $dumpvars(0,ADDR_LOAD, CK, CLEARING, COLOR_INDEX, LOAD, PCK2, SPR_PAL, WE, DATA_OUT);
    end

endmodule
