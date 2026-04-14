`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg reset;
    reg rotate_left;
    reg rotate_right;
    reg select;
    reg [1:0] shift;
    reg shift_left;
    reg shift_right;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .rotate_left(rotate_left),
        .rotate_right(rotate_right),
        .select(select),
        .shift(shift),
        .shift_left(shift_left),
        .shift_right(shift_right),
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
            select = 0;
            data_in = 0;
            shift = 0;
            shift_left = 0;
            shift_right = 0;
            rotate_left = 0;
            rotate_right = 0;
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
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load", test_num);
            reset_dut();
            data_in = 4'hA;
            select = 1;
            @(posedge clk);
            #1;
            select = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left 1", test_num);
            reset_dut();

            data_in = 4'h1;
            select = 1;
            @(posedge clk);
            #1;
            select = 0;

            shift = 2'd1;
            shift_left = 1;
            @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left 2", test_num);
            reset_dut();

            data_in = 4'h3;
            select = 1;
            @(posedge clk);
            #1;
            select = 0;

            shift = 2'd2;
            shift_left = 1;
            @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 1", test_num);
            reset_dut();

            data_in = 4'h8;
            select = 1;
            @(posedge clk);
            #1;
            select = 0;

            shift = 2'd1;
            shift_right = 1;
            @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right 3", test_num);
            reset_dut();

            data_in = 4'hF;
            select = 1;
            @(posedge clk);
            #1;
            select = 0;

            shift = 2'd3;
            shift_right = 1;
            @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Left 1", test_num);
            reset_dut();

            data_in = 4'h9;
            select = 1;
            @(posedge clk);
            #1;
            select = 0;

            shift = 2'd1;
            rotate_left = 1;
            @(posedge clk);
            #1;
            rotate_left = 0;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Left 2", test_num);
            reset_dut();

            data_in = 4'h6;
            select = 1;
            @(posedge clk);
            #1;
            select = 0;

            shift = 2'd2;
            rotate_left = 1;
            @(posedge clk);
            #1;
            rotate_left = 0;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Right 1", test_num);
            reset_dut();

            data_in = 4'h1;
            select = 1;
            @(posedge clk);
            #1;
            select = 0;

            shift = 2'd1;
            rotate_right = 1;
            @(posedge clk);
            #1;
            rotate_right = 0;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Right 3", test_num);
            reset_dut();

            data_in = 4'h4;
            select = 1;
            @(posedge clk);
            #1;
            select = 0;

            shift = 2'd3;
            rotate_right = 1;
            @(posedge clk);
            #1;
            rotate_right = 0;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Ops", test_num);
            reset_dut();

            data_in = 4'h1;
            select = 1;
            @(posedge clk);
            #1;
            select = 0;

            shift = 2'd1;
            shift_left = 1;
            @(posedge clk);
            #1;
            shift_left = 0;

            shift = 2'd1;
            rotate_right = 1;
            @(posedge clk);
            #1;
            rotate_right = 0;
            #1;

            check_outputs(4'h1);
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
        testcase009();
        testcase010();
        testcase011();
        
        
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
        $dumpvars(0,clk, data_in, reset, rotate_left, rotate_right, select, shift, shift_left, shift_right, count);
    end

endmodule
