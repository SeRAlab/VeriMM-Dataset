`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        in = 0;
        forever #5 in = ~in;
    end

        task reset_dut;

        begin
            rst = 1;
            in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Stable High Input", test_num);
            reset_dut();
            in = 1;
            repeat(30) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: High Glitch Rejection", test_num);
            reset_dut();
            in = 1;
            repeat(4) @(posedge clk);
            in = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Low Glitch Rejection", test_num);
            reset_dut();
            in = 1;
            repeat(20) @(posedge clk);
            in = 0;
            repeat(4) @(posedge clk);
            in = 1;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Stable Low Transition", test_num);
            reset_dut();
            in = 1;
            repeat(20) @(posedge clk);
            in = 0;
            repeat(30) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Noisy Input Rejection", test_num);
            reset_dut();

            for (i = 0; i < 10; i = i + 1) begin
                in = 1; repeat(2) @(posedge clk);
                in = 0; repeat(2) @(posedge clk);
            end
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %03d: Stability after Noise", test_num);
            reset_dut();
            for (i = 0; i < 5; i = i + 1) begin
                in = 1; repeat(2) @(posedge clk);
                in = 0; repeat(1) @(posedge clk);
            end
            in = 1;
            repeat(30) @(posedge clk);
            #1;

            check_outputs(1'b1);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,in, out);
    end

endmodule
