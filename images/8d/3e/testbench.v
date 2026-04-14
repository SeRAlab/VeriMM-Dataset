`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg globalReset;
    reg inClk;
    wire outClk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .globalReset(globalReset),
        .inClk(inClk),
        .outClk(outClk)
    );

    // Clock generation (10ns period)
    initial begin
        inClk = 0;
        forever #5 inClk = ~inClk;
    end

        task reset_dut;

    begin
        globalReset = 1;
        repeat(2) @(posedge inClk);
        #2 globalReset = 0;
        repeat(1) @(posedge inClk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase %03d: Checking initial state after reset", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase %03d: Checking state after 5 clock cycles", test_num);
        repeat(5) @(posedge inClk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase %03d: Checking state after 10 clock cycles", test_num);
        repeat(10) @(posedge inClk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase %03d: Checking state after 15 clock cycles", test_num);
        repeat(15) @(posedge inClk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase %03d: Checking state after 20 clock cycles", test_num);
        repeat(20) @(posedge inClk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Testcase %03d: Checking state during first low phase (2 cycles)", test_num);
        repeat(2) @(posedge inClk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        $display("Testcase %03d: Checking state during first high phase (7 cycles)", test_num);
        repeat(7) @(posedge inClk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        $display("Testcase %03d: Checking state during second low phase (12 cycles)", test_num);
        repeat(12) @(posedge inClk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        $display("Testcase %03d: Checking state during second high phase (17 cycles)", test_num);
        repeat(17) @(posedge inClk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();
        $display("Testcase %03d: Testing reset recovery while output is high", test_num);
        repeat(7) @(posedge inClk);
        #1;
        globalReset = 1;
        #20;
        globalReset = 0;
        #1;
        #1;

        check_outputs(1'b0);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_outClk;
        begin
            if (expected_outClk === (expected_outClk ^ outClk ^ expected_outClk)) begin
                $display("PASS");
                $display("  Outputs: outClk=%b",
                         outClk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outClk=%b",
                         expected_outClk);
                $display("  Got:      outClk=%b",
                         outClk);
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
        $dumpvars(0,globalReset, inClk, outClk);
    end

endmodule
