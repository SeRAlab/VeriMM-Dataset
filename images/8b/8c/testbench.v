`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg INCLK;
    reg PLLRDY;
    reg RST_N;
    wire PLLRST;
    wire SYSRST;
    wire SYSRST_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .INCLK(INCLK),
        .PLLRDY(PLLRDY),
        .RST_N(RST_N),
        .PLLRST(PLLRST),
        .SYSRST(SYSRST),
        .SYSRST_N(SYSRST_N)
    );

    // Clock generation (10ns period)
    initial begin
        INCLK = 0;
        forever #5 INCLK = ~INCLK;
    end

        task reset_dut;

    begin
        RST_N = 0;
        PLLRDY = 0;
        repeat(2) @(posedge INCLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Asserted Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: PLLRST release while waiting for PLLRDY", test_num);
        reset_dut();
        RST_N = 1;
        repeat(2) @(posedge INCLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Complete system startup sequence", test_num);
        reset_dut();
        RST_N = 1;
        repeat(2) @(posedge INCLK);
        PLLRDY = 1;
        repeat(2) @(posedge INCLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Re-asserting reset during operation", test_num);
        reset_dut();

        RST_N = 1;
        PLLRDY = 1;
        repeat(3) @(posedge INCLK);

        RST_N = 0;
        repeat(2) @(posedge INCLK);
        #1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_PLLRST;
        input expected_SYSRST;
        input expected_SYSRST_N;
        begin
            if (expected_PLLRST === (expected_PLLRST ^ PLLRST ^ expected_PLLRST) &&
                expected_SYSRST === (expected_SYSRST ^ SYSRST ^ expected_SYSRST) &&
                expected_SYSRST_N === (expected_SYSRST_N ^ SYSRST_N ^ expected_SYSRST_N)) begin
                $display("PASS");
                $display("  Outputs: PLLRST=%b, SYSRST=%b, SYSRST_N=%b",
                         PLLRST, SYSRST, SYSRST_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PLLRST=%b, SYSRST=%b, SYSRST_N=%b",
                         expected_PLLRST, expected_SYSRST, expected_SYSRST_N);
                $display("  Got:      PLLRST=%b, SYSRST=%b, SYSRST_N=%b",
                         PLLRST, SYSRST, SYSRST_N);
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
        $dumpvars(0,INCLK, PLLRDY, RST_N, PLLRST, SYSRST, SYSRST_N);
    end

endmodule
