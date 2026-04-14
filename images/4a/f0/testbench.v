`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg inclk0;
    wire c0;
    wire c1;
    wire c2;
    wire c3;
    wire c4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .inclk0(inclk0),
        .c0(c0),
        .c1(c1),
        .c2(c2),
        .c3(c3),
        .c4(c4)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        #12;
        areset = 0;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Checking outputs after reset...", test_num);
        reset_dut();

        #1;


        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Checking c0 toggle after 1st cycle...", test_num);
        reset_dut();
        @(posedge inclk0);
        #2;
        #1;

        check_outputs(1, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Checking cascading toggles (c0-c2)...", test_num);
        reset_dut();
        repeat(3) @(posedge inclk0);
        #2;
        #1;

        check_outputs(1, 1, 1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Checking all outputs high after 5 cycles...", test_num);
        reset_dut();
        repeat(5) @(posedge inclk0);
        #2;
        #1;

        check_outputs(1, 1, 1, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Checking cascading 1->0 transition (c0)...", test_num);
        reset_dut();
        repeat(6) @(posedge inclk0);
        #2;
        #1;

        check_outputs(0, 1, 1, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Checking full cycle completion (10 cycles)...", test_num);
        reset_dut();
        repeat(10) @(posedge inclk0);
        #2;
        #1;

        check_outputs(0, 0, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Checking wraparound behavior (11 cycles)...", test_num);
        reset_dut();
        repeat(11) @(posedge inclk0);
        #2;
        #1;

        check_outputs(1, 0, 0, 0, 0);
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
        input expected_c0;
        input expected_c1;
        input expected_c2;
        input expected_c3;
        input expected_c4;
        begin
            if (expected_c0 === (expected_c0 ^ c0 ^ expected_c0) &&
                expected_c1 === (expected_c1 ^ c1 ^ expected_c1) &&
                expected_c2 === (expected_c2 ^ c2 ^ expected_c2) &&
                expected_c3 === (expected_c3 ^ c3 ^ expected_c3) &&
                expected_c4 === (expected_c4 ^ c4 ^ expected_c4)) begin
                $display("PASS");
                $display("  Outputs: c0=%b, c1=%b, c2=%b, c3=%b, c4=%b",
                         c0, c1, c2, c3, c4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c0=%b, c1=%b, c2=%b, c3=%b, c4=%b",
                         expected_c0, expected_c1, expected_c2, expected_c3, expected_c4);
                $display("  Got:      c0=%b, c1=%b, c2=%b, c3=%b, c4=%b",
                         c0, c1, c2, c3, c4);
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
        $dumpvars(0,areset, inclk0, c0, c1, c2, c3, c4);
    end

endmodule
