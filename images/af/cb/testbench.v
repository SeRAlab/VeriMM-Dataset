`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    reg select_counter;
    reg select_output;
    reg up_down;
    wire [3:0] count_out;
    wire [3:0] sum_out;

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
        .select_counter(select_counter),
        .select_output(select_output),
        .up_down(up_down),
        .count_out(count_out),
        .sum_out(sum_out)
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
            up_down = 1;
            data_in = 0;
            select_counter = 0;
            select_output = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Load Counter 1", test_num);
            reset_dut();
            data_in = 4'hA;
            load = 1;
            select_counter = 0;
            @(posedge clk);
            #1;
            load = 0;
            select_output = 0;
            select_counter = 0;



            #1;




            check_outputs(4'hA, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Load Counter 2", test_num);
            reset_dut();
            data_in = 4'h5;
            load = 1;
            select_counter = 1;
            @(posedge clk);
            #1;
            load = 0;
            select_counter = 1;
            select_output = 0;

            #1;


            check_outputs(4'h5, 4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Increment counters", test_num);
            reset_dut();
            up_down = 1;
            @(posedge clk);
            #1;
            select_output = 0;
            select_counter = 0;

            #1;


            check_outputs(4'h1, 4'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Decrement counters (wrap around)", test_num);
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1;
            select_output = 0;
            select_counter = 0;

            #1;


            check_outputs(4'hF, 4'hE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Select Sum for count_out", test_num);
            reset_dut();

            data_in = 4'h3; load = 1; select_counter = 0; @(posedge clk); #1;

            data_in = 4'h4; load = 1; select_counter = 1; @(posedge clk); #1;

            load = 0;
            select_output = 1;


            #1;



            check_outputs(4'h7, 4'h7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Load then Increment", test_num);
            reset_dut();

            data_in = 4'h7; load = 1; select_counter = 0; @(posedge clk); #1;
            load = 0; up_down = 1;
            @(posedge clk);
            #1;
            select_counter = 0; select_output = 0;

            #1;


            check_outputs(4'h8, 4'h9);
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
        input [3:0] expected_count_out;
        input [3:0] expected_sum_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, sum_out=%h",
                         count_out, sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, sum_out=%h",
                         expected_count_out, expected_sum_out);
                $display("  Got:      count_out=%h, sum_out=%h",
                         count_out, sum_out);
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
        $dumpvars(0,clk, data_in, load, reset, select_counter, select_output, up_down, count_out, sum_out);
    end

endmodule
