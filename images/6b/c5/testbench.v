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
            LOAD = 1;
            SHIFT = 0;
            DATA_IN = 16'h0000;
            mode = 0;
            @(posedge CLK);
            #1;
            LOAD = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Load data 0xABCD", test_num);
            LOAD = 1;
            DATA_IN = 16'hABCD;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Shift Left Mode 1 (Append 0) from 0xFFFF", test_num);

            LOAD = 1; DATA_IN = 16'hFFFF; @(posedge CLK); #1;

            LOAD = 0; SHIFT = 1; mode = 1; @(posedge CLK); #1;
            SHIFT = 0;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Shift Left Mode 0 (Append 1) from 0x0000", test_num);

            LOAD = 1; DATA_IN = 16'h0000; @(posedge CLK); #1;

            LOAD = 0; SHIFT = 1; mode = 0; @(posedge CLK); #1;
            SHIFT = 0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: 16 Consecutive Shifts Mode 1 (Append 0)", test_num);
            LOAD = 1; DATA_IN = 16'hFFFF; @(posedge CLK); #1;
            LOAD = 0; SHIFT = 1; mode = 1;
            repeat(16) @(posedge CLK);
            #1;
            SHIFT = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: 16 Consecutive Shifts Mode 0 (Append 1)", test_num);
            LOAD = 1; DATA_IN = 16'h0000; @(posedge CLK); #1;
            LOAD = 0; SHIFT = 1; mode = 0;
            repeat(16) @(posedge CLK);
            #1;
            SHIFT = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Check LOAD priority over SHIFT", test_num);
            LOAD = 1;
            SHIFT = 1;
            DATA_IN = 16'h1234;
            mode = 1;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SHIFT = 0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: Verify Hold State (LOAD=0, SHIFT=0)", test_num);
            LOAD = 1; DATA_IN = 16'h5555; @(posedge CLK); #1;
            LOAD = 0; SHIFT = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h5555);
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
