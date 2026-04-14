`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [15:0] DATA_IN;
    reg LOAD;
    reg SHIFT;
    reg mode;
    wire [15:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD(LOAD),
        .SHIFT(SHIFT),
        .mode(mode),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 0;
            SHIFT = 0;
            mode = 0;
            DATA_IN = 16'h0000;
            repeat(2) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Load Mode 0", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 16'hAAAA;
            mode = 0;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Load Mode 1", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 16'h5555;
            mode = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Shift Mode 0", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 16'h1234;
            mode = 0;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT = 1;
            @(posedge CLK);
            #1;
            SHIFT = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Multiple Shifts Mode 1", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 16'hABCD;
            mode = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT = 1;
            repeat(3) @(posedge CLK);
            #1;
            SHIFT = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Full Shift Out", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 16'hFFFF;
            mode = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT = 1;
            repeat(4) @(posedge CLK);
            #1;
            SHIFT = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Priority Check (LOAD vs SHIFT)", test_num);
            reset_dut();

            LOAD = 1;
            DATA_IN = 16'h1111;
            mode = 0;
            @(posedge CLK);
            #1;

            LOAD = 1;
            SHIFT = 1;
            DATA_IN = 16'h2222;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT = 0;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Data Retention (Idle)", test_num);
            reset_dut();
            LOAD = 1;
            DATA_IN = 16'hBEEF;
            mode = 0;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(16'hBEEF);
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
        testcase007();
        
        
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
        input [15:0] expected_DATA_OUT;
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
        $dumpvars(0,CLK, DATA_IN, LOAD, SHIFT, mode, DATA_OUT);
    end

endmodule
