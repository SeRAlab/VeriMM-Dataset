`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg [3:0] load_data;
    reg parallel_load;
    reg rst_n;
    reg select;
    reg shift_left;
    reg shift_right;
    reg up_down;
    wire [3:0] count;
    wire [3:0] final_output;
    wire [3:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load_data(load_data),
        .parallel_load(parallel_load),
        .rst_n(rst_n),
        .select(select),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .up_down(up_down),
        .count(count),
        .final_output(final_output),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            up_down = 0;
            load_data = 0;
            shift_left = 0;
            shift_right = 0;
            parallel_load = 0;
            data_in = 0;
            select = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Up Counter Verification", test_num);
            reset_dut();
            up_down = 1;
            load_data = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Down Counter Verification", test_num);
            reset_dut();
            up_down = 0;
            load_data = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hE, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Counter Parallel Load", test_num);
            reset_dut();
            load_data = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Shift Register Parallel Load", test_num);
            reset_dut();
            parallel_load = 1;
            data_in = 4'hC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'hC, 4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Shift Left Operation", test_num);
            reset_dut();
            parallel_load = 1;
            data_in = 4'h1;
            @(posedge clk);
            #1;
            parallel_load = 0;
            shift_left = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h4, 4'h4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Shift Right Operation", test_num);
            reset_dut();
            parallel_load = 1;
            data_in = 4'h8;
            @(posedge clk);
            #1;
            parallel_load = 0;
            shift_right = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h2, 4'h2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: XOR Output Verification", test_num);
            reset_dut();
            load_data = 4'hF;
            parallel_load = 1;
            data_in = 4'h5;
            select = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF, 4'hA, 4'h5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Shift Out Selection", test_num);
            reset_dut();
            load_data = 4'hF;
            parallel_load = 1;
            data_in = 4'h5;
            select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 4'h5, 4'h5);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Counter Overflow Verification", test_num);
            reset_dut();
            load_data = 4'hF;
            @(posedge clk);
            #1;
            load_data = 0;
            up_down = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h0, 4'h0);
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
        input [3:0] expected_final_output;
        input [3:0] expected_shift_out;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: count=%h, final_output=%h, shift_out=%h",
                         count, final_output, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, final_output=%h, shift_out=%h",
                         expected_count, expected_final_output, expected_shift_out);
                $display("  Got:      count=%h, final_output=%h, shift_out=%h",
                         count, final_output, shift_out);
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
        $dumpvars(0,clk, data_in, load_data, parallel_load, rst_n, select, shift_left, shift_right, up_down, count, final_output, shift_out);
    end

endmodule
