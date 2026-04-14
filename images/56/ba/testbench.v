`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] parallel_in;
    reg serial_in;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .serial_in(serial_in),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            parallel_in = 4'b1111;
            serial_in = 1'b0;
            @(posedge clk);
            parallel_in = 4'b0000;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load (Even Value)", test_num);
            reset_dut();
            parallel_in = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load (Odd Value)", test_num);
            reset_dut();
            parallel_in = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Left (Serial In 0)", test_num);
            reset_dut();
            parallel_in = 4'b1111;
            @(posedge clk);
            parallel_in = 4'b0000;
            serial_in = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Left (Serial In 1)", test_num);
            reset_dut();
            parallel_in = 4'b1110;
            @(posedge clk);
            parallel_in = 4'b0000;
            serial_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Priority Test", test_num);
            reset_dut();
            parallel_in = 4'b0110;
            serial_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Serial Shift Sequence", test_num);
            reset_dut();
            parallel_in = 4'b1000;
            @(posedge clk);
            parallel_in = 4'b0000; serial_in = 1'b1; @(posedge clk);
            parallel_in = 4'b0000; serial_in = 1'b1; @(posedge clk);
            parallel_in = 4'b0000; serial_in = 1'b0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift to All Zeros", test_num);
            reset_dut();
            parallel_in = 4'b0001;
            @(posedge clk);
            parallel_in = 4'b0000; serial_in = 1'b0; @(posedge clk);
            parallel_in = 4'b0000; serial_in = 1'b0; @(posedge clk);
            parallel_in = 4'b0000; serial_in = 1'b0; @(posedge clk);
            parallel_in = 4'b0000; serial_in = 1'b0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, parallel_in, serial_in, serial_out);
    end

endmodule
