`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg in_valid;
    reg out_ready;
    reg reset;
    wire in_ready;
    wire [7:0] out_data;
    wire out_error;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .in_valid(in_valid),
        .out_ready(out_ready),
        .reset(reset),
        .in_ready(in_ready),
        .out_data(out_data),
        .out_error(out_error),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_data = 8'h00;
            in_valid = 0;
            out_ready = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal immediate transfer", test_num);
            reset_dut();

            @(posedge clk);
            in_data = 8'hA5;
            in_valid = 1;
            out_ready = 1;

            @(posedge clk);

            #1;
            #1;

            check_outputs(1, 8'hA5, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Delayed output readiness", test_num);
            reset_dut();

            @(posedge clk);
            in_data = 8'h3C;
            in_valid = 1;
            out_ready = 0;


            repeat(3) @(posedge clk);
            out_ready = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 8'h3C, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Timeout error check", test_num);
            reset_dut();

            @(posedge clk);
            in_data = 8'hFF;
            in_valid = 1;
            out_ready = 0;


            repeat(20) @(posedge clk);

            #1;

            if (out_error === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Error detected correctly");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Error NOT detected correctly");
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle state check", test_num);
            reset_dut();


            #1;
            #1;

            check_outputs(0, 8'h00, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Back-to-back transfers", test_num);
            reset_dut();

            @(posedge clk);
            in_valid = 1;
            out_ready = 1;


            in_data = 8'h11;
            @(posedge clk);


            in_data = 8'h22;
            @(posedge clk);


            in_data = 8'h33;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1, 8'h33, 0, 1);
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
        input expected_in_ready;
        input [7:0] expected_out_data;
        input expected_out_error;
        input expected_out_valid;
        begin
            if (expected_in_ready === (expected_in_ready ^ in_ready ^ expected_in_ready) &&
                expected_out_data === (expected_out_data ^ out_data ^ expected_out_data) &&
                expected_out_error === (expected_out_error ^ out_error ^ expected_out_error) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: in_ready=%b, out_data=%h, out_error=%b, out_valid=%b",
                         in_ready, out_data, out_error, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_ready=%b, out_data=%h, out_error=%b, out_valid=%b",
                         expected_in_ready, expected_out_data, expected_out_error, expected_out_valid);
                $display("  Got:      in_ready=%b, out_data=%h, out_error=%b, out_valid=%b",
                         in_ready, out_data, out_error, out_valid);
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
        $dumpvars(0,clk, in_data, in_valid, out_ready, reset, in_ready, out_data, out_error, out_valid);
    end

endmodule
