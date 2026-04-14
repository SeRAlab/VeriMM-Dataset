`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg dir;
    wire [2:0] count;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .dir(dir),
        .count(count),
        .cout(cout)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        dir = 1;
        #12;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Basic Incrementing to 3", test_num);
        reset_dut();
        dir = 1;
        repeat(3) @(posedge clk);
        #2;
        #1;

        check_outputs(3'b011, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Overflow Wrap-around (7 to 0)", test_num);
        reset_dut();
        dir = 1;
        repeat(8) @(posedge clk);
        #2;
        #1;

        check_outputs(3'b000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Underflow Wrap-around (0 to 7)", test_num);
        reset_dut();
        dir = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'b111, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Direction Change Mid-stream", test_num);
        reset_dut();
        dir = 1;
        repeat(5) @(posedge clk);
        dir = 0;
        repeat(2) @(posedge clk);
        #2;
        #1;

        check_outputs(3'b011, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Boundary reaching (Count=7, cout=0)", test_num);
        reset_dut();
        dir = 1;
        repeat(7) @(posedge clk);
        #2;
        #1;

        check_outputs(3'b111, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Multiple Underflows", test_num);
        reset_dut();
        dir = 0;
        repeat(9) @(posedge clk);
        #2;
        #1;

        check_outputs(3'b111, 1'b1);
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
        input [2:0] expected_count;
        input expected_cout;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: count=%h, cout=%b",
                         count, cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, cout=%b",
                         expected_count, expected_cout);
                $display("  Got:      count=%h, cout=%b",
                         count, cout);
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
        $dumpvars(0,areset, clk, dir, count, cout);
    end

endmodule
