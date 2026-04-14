`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg count_enable;
    reg reset;
    reg [3:0] shift_in;
    reg shift_load;
    reg up_down;
    wire [3:0] count;
    wire max_reached;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .count_enable(count_enable),
        .reset(reset),
        .shift_in(shift_in),
        .shift_load(shift_load),
        .up_down(up_down),
        .count(count),
        .max_reached(max_reached),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            count_enable = 0;
            shift_in = 4'b0000;
            shift_load = 0;
            up_down = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power-on Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b1, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load Shift Register", test_num);
            reset_dut();
            shift_in = 4'b1010;
            shift_load = 1;
            @(posedge clk);
            #1;
            shift_load = 0;

            #1;


            check_outputs(4'h0, 1'b1, 8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Counter Increment", test_num);
            reset_dut();
            shift_load = 1;
            shift_in = 4'b0000;
            @(posedge clk);
            #1;
            shift_load = 0;
            count_enable = 1;
            up_down = 1;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5, 1'b0, 8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Counter Rollover (Up)", test_num);
            reset_dut();
            count_enable = 1;
            up_down = 1;
            repeat (16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Counter Rollover (Down)", test_num);
            reset_dut();
            count_enable = 1;
            up_down = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 1'b1, 8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Cyclic Shift and Result Calculation", test_num);
            reset_dut();

            shift_in = 4'b1000;
            shift_load = 1;
            @(posedge clk);
            #1;
            shift_load = 0;



            count_enable = 1;
            up_down = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1, 1'b0, 8'h02);
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
        input [3:0] expected_count;
        input expected_max_reached;
        input [7:0] expected_result;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_max_reached === (expected_max_reached ^ max_reached ^ expected_max_reached) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: count=%h, max_reached=%b, result=%h",
                         count, max_reached, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, max_reached=%b, result=%h",
                         expected_count, expected_max_reached, expected_result);
                $display("  Got:      count=%h, max_reached=%b, result=%h",
                         count, max_reached, result);
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
        $dumpvars(0,clk, count_enable, reset, shift_in, shift_load, up_down, count, max_reached, result);
    end

endmodule
