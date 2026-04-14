`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_data;
    reg input_valid;
    reg rst;
    wire [7:0] output_data;
    wire output_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_data(input_data),
        .input_valid(input_valid),
        .rst(rst),
        .output_data(output_data),
        .output_valid(output_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        input_data = 8'h0;
        input_valid = 0;
        @(posedge clk);
        #2;
        rst = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Data Capture", test_num);
        reset_dut();
        input_data = 8'hA5;
        input_valid = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'hA5, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Invalid Input Signal Handling", test_num);
        reset_dut();

        input_data = 8'h5A;
        input_valid = 1;
        @(posedge clk);
        #2;

        input_valid = 0;
        input_data = 8'hFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h5A, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Consecutive Captures", test_num);
        reset_dut();

        input_data = 8'h11;
        input_valid = 1;
        @(posedge clk);
        #2;

        input_data = 8'h22;
        input_valid = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h22, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Data Persistence", test_num);
        reset_dut();
        input_data = 8'hBC;
        input_valid = 1;
        @(posedge clk);
        #2;
        input_valid = 0;
        input_data = 8'h00;
        repeat(3) @(posedge clk);
        #2;

        #1;


        check_outputs(8'hBC, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronous Reset Check", test_num);
        reset_dut();
        input_data = 8'h66;
        input_valid = 1;
        @(posedge clk);
        #2;
        rst = 1;
        @(posedge clk);
        #2;

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
        input [7:0] expected_output_data;
        input expected_output_valid;
        begin
            if (expected_output_data === (expected_output_data ^ output_data ^ expected_output_data) &&
                expected_output_valid === (expected_output_valid ^ output_valid ^ expected_output_valid)) begin
                $display("PASS");
                $display("  Outputs: output_data=%h, output_valid=%b",
                         output_data, output_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_data=%h, output_valid=%b",
                         expected_output_data, expected_output_valid);
                $display("  Got:      output_data=%h, output_valid=%b",
                         output_data, output_valid);
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
        $dumpvars(0,clk, input_data, input_valid, rst, output_data, output_valid);
    end

endmodule
