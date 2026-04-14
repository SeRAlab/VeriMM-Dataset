`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear_input;
    reg clk;
    reg [3:0] parallel_input;
    reg parallel_load;
    reg rst;
    reg serial_input;
    reg shift_dir;
    wire [3:0] parallel_output;
    wire serial_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear_input(clear_input),
        .clk(clk),
        .parallel_input(parallel_input),
        .parallel_load(parallel_load),
        .rst(rst),
        .serial_input(serial_input),
        .shift_dir(shift_dir),
        .parallel_output(parallel_output),
        .serial_output(serial_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clear_input = 0;
            parallel_load = 0;
            parallel_input = 4'b0000;
            serial_input = 0;
            shift_dir = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Parallel Load 4'b1011", test_num);
            reset_dut();
            parallel_load = 1;
            parallel_input = 4'b1011;
            @(posedge clk);
            #2 parallel_load = 0;
            #1;

            check_outputs(4'b1011, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Synchronous Clear", test_num);
            reset_dut();

            parallel_load = 1;
            parallel_input = 4'b1111;
            @(posedge clk);
            #2 parallel_load = 0;

            clear_input = 1;
            @(posedge clk);
            #2 clear_input = 0;
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Shift Left with Serial Input 1", test_num);
            reset_dut();

            parallel_load = 1;
            parallel_input = 4'b0101;
            @(posedge clk);
            #2 parallel_load = 0;
            shift_dir = 1;
            serial_input = 1;
            @(posedge clk);

            #2 #1;
 check_outputs(4'b1011, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Shift Right with Serial Input 0", test_num);
            reset_dut();

            parallel_load = 1;
            parallel_input = 4'b1010;
            @(posedge clk);
            #2 parallel_load = 0;
            shift_dir = 0;
            serial_input = 0;
            @(posedge clk);

            #2 #1;
 check_outputs(4'b0101, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple Shift Lefts", test_num);
            reset_dut();
            shift_dir = 1;
            serial_input = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2 #1;
 check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Multiple Shift Rights Mixed Input", test_num);
            reset_dut();
            shift_dir = 0;
            serial_input = 1; @(posedge clk);
            serial_input = 1; @(posedge clk);
            serial_input = 0; @(posedge clk);
            serial_input = 1; @(posedge clk);
            #2 #1;
 check_outputs(4'b1011, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Priority Check (Clear vs Load)", test_num);
            reset_dut();
            clear_input = 1;
            parallel_load = 1;
            parallel_input = 4'b1111;
            @(posedge clk);
            #2;

            if (parallel_output == 4'b0000) begin
                $display("Priority: Clear > Load");
                #1;

                check_outputs(4'b0000, 1'b0);
            end else begin
                $display("Priority: Load > Clear");
                #1;

                check_outputs(4'b1111, 1'b1);
            end
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
        input [3:0] expected_parallel_output;
        input expected_serial_output;
        begin
            if (expected_parallel_output === (expected_parallel_output ^ parallel_output ^ expected_parallel_output) &&
                expected_serial_output === (expected_serial_output ^ serial_output ^ expected_serial_output)) begin
                $display("PASS");
                $display("  Outputs: parallel_output=%h, serial_output=%b",
                         parallel_output, serial_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_output=%h, serial_output=%b",
                         expected_parallel_output, expected_serial_output);
                $display("  Got:      parallel_output=%h, serial_output=%b",
                         parallel_output, serial_output);
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
        $dumpvars(0,clear_input, clk, parallel_input, parallel_load, rst, serial_input, shift_dir, parallel_output, serial_output);
    end

endmodule
