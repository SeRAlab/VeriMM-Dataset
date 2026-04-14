`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ACLR_L;
    reg CLKIN;
    wire CLKOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ACLR_L(ACLR_L),
        .CLKIN(CLKIN),
        .CLKOUT(CLKOUT)
    );

    // Clock generation (10ns period)
    initial begin
        ACLR_L = 0;
        forever #5 ACLR_L = ~ACLR_L;
    end

        task reset_dut;

    begin
        ACLR_L = 0;
        #20;
        ACLR_L = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Check output immediately after reset", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Check output toggles high after 50 cycles", test_num);
        reset_dut();
        repeat(50) @(posedge CLKIN);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Check output toggles low after 100 cycles", test_num);
        reset_dut();
        repeat(100) @(posedge CLKIN);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Check output toggles high again after 150 cycles", test_num);
        reset_dut();
        repeat(150) @(posedge CLKIN);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Test asynchronous reset while CLKOUT is high", test_num);
        reset_dut();

        repeat(50) @(posedge CLKIN);
        #1;

        ACLR_L = 0;
        #5;
        #1;

        check_outputs(1'b0);
        ACLR_L = 1;
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
        input expected_CLKOUT;
        begin
            if (expected_CLKOUT === (expected_CLKOUT ^ CLKOUT ^ expected_CLKOUT)) begin
                $display("PASS");
                $display("  Outputs: CLKOUT=%b",
                         CLKOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLKOUT=%b",
                         expected_CLKOUT);
                $display("  Got:      CLKOUT=%b",
                         CLKOUT);
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
        $dumpvars(0,ACLR_L, CLKIN, CLKOUT);
    end

endmodule
