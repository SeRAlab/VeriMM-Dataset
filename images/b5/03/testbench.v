`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg rst;
    reg [7:0] serial_in;
    reg shift_dir;
    wire [7:0] parallel_out;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .rst(rst),
        .serial_in(serial_in),
        .shift_dir(shift_dir),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            serial_in = 8'h00;
            shift_dir = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Verifying Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Parallel Load 8'hA5", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            serial_in = 8'hA5;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load 8'h01 and Shift Left", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            serial_in = 8'h01;
            @(posedge clk);
            #1 load = 0;
            shift_dir = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h02, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Load 8'h80 and Shift Right", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            serial_in = 8'h80;
            @(posedge clk);
            #1 load = 0;
            shift_dir = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h40, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multi-cycle Shift Left (4 positions)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            serial_in = 8'hFF;
            @(posedge clk);
            #1 load = 0;
            shift_dir = 0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hF0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multi-cycle Shift Right (4 positions)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            serial_in = 8'hFF;
            @(posedge clk);
            #1 load = 0;
            shift_dir = 1;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0F, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Full Shift Out Left", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            serial_in = 8'hAA;
            @(posedge clk);
            #1 load = 0;
            shift_dir = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_parallel_out;
        input expected_serial_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, serial_out=%b",
                         parallel_out, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, serial_out=%b",
                         expected_parallel_out, expected_serial_out);
                $display("  Got:      parallel_out=%h, serial_out=%b",
                         parallel_out, serial_out);
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
        $dumpvars(0,clk, load, rst, serial_in, shift_dir, parallel_out, serial_out);
    end

endmodule
