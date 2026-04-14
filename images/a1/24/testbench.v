`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enter;
    reg gameEnd;
    reg resetn;
    wire start;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enter(enter),
        .gameEnd(gameEnd),
        .resetn(resetn),
        .start(start)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        enter = 0;
        gameEnd = 0;
        @(posedge clk);
        #2 resetn = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset State Check", test_num);
        reset_dut();
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: S_IDLE -> S_STAY transition", test_num);
        reset_dut();
        enter = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: S_STAY -> S_IDLE transition", test_num);
        reset_dut();
        enter = 1;
        @(posedge clk);
        #1 enter = 0;
        gameEnd = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Remain in S_IDLE", test_num);
        reset_dut();
        enter = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Remain in S_STAY", test_num);
        reset_dut();
        enter = 1;
        @(posedge clk);
        #1 enter = 0;
        gameEnd = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Async-style Reset from S_STAY", test_num);
        reset_dut();
        enter = 1;
        @(posedge clk);
        #1 enter = 0;
        resetn = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Full cycle sequence", test_num);
        reset_dut();
        enter = 1;
        @(posedge clk);
        #1 enter = 0; gameEnd = 1;
        @(posedge clk);
        #1 gameEnd = 0; enter = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1);
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
        input expected_start;
        begin
            if (expected_start === (expected_start ^ start ^ expected_start)) begin
                $display("PASS");
                $display("  Outputs: start=%b",
                         start);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: start=%b",
                         expected_start);
                $display("  Got:      start=%b",
                         start);
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
        $dumpvars(0,clk, enter, gameEnd, resetn, start);
    end

endmodule
