`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load_down;
    reg load_up;
    reg reset;
    reg up_down;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load_down(load_down),
        .load_up(load_up),
        .reset(reset),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load_up = 0;
            load_down = 0;
            up_down = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Increment wrap-around (15->0)", test_num);
            reset_dut();
            up_down = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multiple increments", test_num);
            reset_dut();
            up_down = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Single decrement", test_num);
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd14);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Decrement wrap-around", test_num);
            reset_dut();
            up_down = 0;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Load Up functionality", test_num);
            reset_dut();
            up_down = 1;
            repeat(2) @(posedge clk);
            load_up = 1;
            @(posedge clk);
            #1;
            load_up = 0;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Load Down functionality", test_num);
            reset_dut();
            up_down = 0;
            repeat(5) @(posedge clk);
            load_down = 1;
            @(posedge clk);
            #1;
            load_down = 0;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Interleaved Up/Down", test_num);
            reset_dut();
            up_down = 1;
            repeat(5) @(posedge clk);
            up_down = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd2);
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
        input [7:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, load_down, load_up, reset, up_down, count);
    end

endmodule
