`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [6:0] load_value;
    reg reset;
    wire [6:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .count(count)
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
            load_value = 0;
            @(negedge clk);
            reset = 0;
            $display("Task: Reset complete");
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset state check");
            reset_dut();

            #1;


            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Load 7'h7F (Max value)");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 7'h7F;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(7'h7F);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Down counting from 10 to 5");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 7'd10;
            @(negedge clk);
            load = 0;





            repeat(5) @(negedge clk);
            #1;

            check_outputs(7'd5);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Wrap-around check (0 to 127)");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 7'd1;
            @(negedge clk);
            load = 0;


            repeat(2) @(negedge clk);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Load priority over decrementing");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 7'd50;
            @(negedge clk);
            load = 0;
            @(negedge clk);


            @(negedge clk);
            load = 1;
            load_value = 7'd100;
            @(negedge clk);
            load = 0;


            #1;



            check_outputs(7'd100);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Count down to zero");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 7'd5;
            @(negedge clk);
            load = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(7'd0);
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
        input [6:0] expected_count;
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
        $dumpvars(0,clk, load, load_value, reset, count);
    end

endmodule
