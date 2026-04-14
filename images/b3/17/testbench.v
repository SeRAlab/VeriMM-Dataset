`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    reg shift_left;
    reg shift_right;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            data_in = 4'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load and Shift Right (3 Stages)", test_num);
            reset_dut();


            data_in = 4'hA;
            load = 1;
            @(posedge clk); #1;
            load = 0;


            shift_right = 1;
            @(posedge clk); #1;


            @(posedge clk); #1;
            shift_right = 0;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load and Shift Left (3 Stages)", test_num);
            reset_dut();


            data_in = 4'h5;
            load = 1;
            @(posedge clk); #1;
            load = 0;


            shift_left = 1;
            @(posedge clk); #1;


            @(posedge clk); #1;
            shift_left = 0;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Incomplete Shift (2 Stages only)", test_num);
            reset_dut();

            data_in = 4'hF;
            load = 1;
            @(posedge clk); #1;
            load = 0;

            shift_right = 1;
            @(posedge clk); #1;
            shift_right = 0;


            #1;



            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Flow (Multiple Values)", test_num);
            reset_dut();


            data_in = 4'h1; load = 1; shift_right = 1; @(posedge clk); #1;

            data_in = 4'h2; load = 1; shift_right = 1; @(posedge clk); #1;

            data_in = 4'h3; load = 1; shift_right = 1; @(posedge clk); #1;

            load = 0;
            shift_right = 0;

            #1;


            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Operation", test_num);
            reset_dut();

            data_in = 4'hE;
            load = 1; @(posedge clk); #1;
            load = 0; shift_right = 1; @(posedge clk); #1;


            reset = 1;
            @(posedge clk); #1;
            reset = 0;


            shift_right = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load, reset, shift_left, shift_right, data_out);
    end

endmodule
