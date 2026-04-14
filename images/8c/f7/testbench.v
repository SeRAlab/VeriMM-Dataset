`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst_n;
    reg valid_in;
    wire [9:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            valid_in = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Basic shift and accumulate (1, 1, 1)", test_num);

            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(10'h013, 1'b1);
            valid_in = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Varying data bits (1, 0, 1)", test_num);

            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            valid_in = 1; data_in = 0;
            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(10'h00D, 1'b1);
            valid_in = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Extended sequence (1, 1, 1, 1)", test_num);

            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(10'h02F, 1'b1);
            valid_in = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: valid_in pulse gaps", test_num);

            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            valid_in = 0; data_in = 1;
            @(posedge clk);
            valid_in = 0; data_in = 0;
            @(posedge clk);
            valid_in = 1; data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(10'h007, 1'b1);
            valid_in = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Reset validation", test_num);
            #1 #1;
 check_outputs(10'h000, 1'b0);
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
        input [9:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst_n, valid_in, data_out, valid_out);
    end

endmodule
