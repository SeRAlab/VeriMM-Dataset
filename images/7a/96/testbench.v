`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg count;
    reg direction;
    reg reset;
    wire [7:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count(count),
        .direction(direction),
        .reset(reset),
        .data_o(data_o)
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
            count = 0;
            direction = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Increment", test_num);
            reset_dut();
            @(negedge clk);
            count = 1;
            direction = 0;
            repeat (10) @(negedge clk);
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Decrement", test_num);
            reset_dut();
            @(negedge clk);
            count = 1;
            direction = 1;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count Enable Check", test_num);
            reset_dut();
            @(negedge clk);
            count = 1;
            direction = 0;
            repeat (5) @(negedge clk);
            count = 0;
            repeat (10) @(negedge clk);
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Upward Rollover", test_num);
            reset_dut();
            @(negedge clk);
            count = 1;
            direction = 0;
            repeat (256) @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Direction Switching", test_num);
            reset_dut();
            @(negedge clk);
            count = 1;
            direction = 0;
            repeat (15) @(negedge clk);
            direction = 1;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous-like Reset behavior", test_num);
            reset_dut();
            @(negedge clk);
            count = 1;
            direction = 0;
            repeat (20) @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Value Transition", test_num);
            reset_dut();
            @(negedge clk);
            count = 1;
            direction = 1;
            repeat (1) @(negedge clk);
            direction = 1;
            repeat (1) @(negedge clk);
            #1;

            check_outputs(8'hFE);
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
        input [7:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,clk, count, direction, reset, data_o);
    end

endmodule
