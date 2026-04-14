`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg reset;
    reg up_down;
    wire [2:0] count;
    wire max_min_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .reset(reset),
        .up_down(up_down),
        .count(count),
        .max_min_flag(max_min_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        load = 0;
        up_down = 1;
        @(negedge clk);
        reset = 0;
        $display("\nDUT Reset complete.");
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Basic Reset", test_num);
        reset_dut();

        #1;


        check_outputs(3'b000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Up Counting to mid-range", test_num);
        reset_dut();
        up_down = 1;

        repeat(4) @(negedge clk);
        #1;

        check_outputs(3'b100, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Down Counting Wrap (0 to 7)", test_num);
        reset_dut();
        up_down = 0;

        @(negedge clk);

        #1;


        check_outputs(3'b111, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Up Counting Wrap (7 to 0)", test_num);
        reset_dut();
        up_down = 1;

        repeat(8) @(negedge clk);
        #1;

        check_outputs(3'b000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Load Signal (Synchronous Clear)", test_num);
        reset_dut();
        up_down = 1;
        repeat(3) @(negedge clk);
        load = 1;
        @(negedge clk);
        load = 0;
        #1;

        check_outputs(3'b000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Max Value (7) Flag Verification", test_num);
        reset_dut();
        up_down = 1;
        repeat(7) @(negedge clk);
        #1;

        check_outputs(3'b111, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Direction Change mid-sequence", test_num);
        reset_dut();
        up_down = 1;
        repeat(5) @(negedge clk);
        up_down = 0;
        repeat(2) @(negedge clk);
        #1;

        check_outputs(3'b011, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Down counting to 0", test_num);
        reset_dut();
        up_down = 0;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        #1;

        check_outputs(3'b000, 1'b1);
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
        input expected_max_min_flag;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_max_min_flag === (expected_max_min_flag ^ max_min_flag ^ expected_max_min_flag)) begin
                $display("PASS");
                $display("  Outputs: count=%h, max_min_flag=%b",
                         count, max_min_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, max_min_flag=%b",
                         expected_count, expected_max_min_flag);
                $display("  Got:      count=%h, max_min_flag=%b",
                         count, max_min_flag);
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
        $dumpvars(0,clk, load, reset, up_down, count, max_min_flag);
    end

endmodule
