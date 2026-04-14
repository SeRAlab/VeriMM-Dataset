`timescale 1ns/1ps

module lzw_compression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_data;
    reg reset;
    wire [15:0] output_code;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compression dut (
        .clk(clk),
        .input_data(input_data),
        .reset(reset),
        .output_code(output_code),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase001: Simple string 'AB'...");
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h42;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase002: Simple string 'ABC'...");
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h42;
            @(posedge clk);
            input_data = 8'h43;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0042, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase003: Compressed sequence 'ABABC'...");
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h42;
            @(posedge clk);
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h42;
            @(posedge clk);
            input_data = 8'h43;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd256, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase004: Repeating characters 'AAAAAB'...");
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h42;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd256, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Running testcase005: Multi-level dictionary match 'ABABABC'...");
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h42;
            @(posedge clk);
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h42;
            @(posedge clk);
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h42;
            @(posedge clk);
            input_data = 8'h41;
            @(posedge clk);
            input_data = 8'h43;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd258, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_compression Testbench");
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
        input [15:0] expected_output_code;
        input expected_valid;
        begin
            if (expected_output_code === (expected_output_code ^ output_code ^ expected_output_code) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: output_code=%h, valid=%b",
                         output_code, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_code=%h, valid=%b",
                         expected_output_code, expected_valid);
                $display("  Got:      output_code=%h, valid=%b",
                         output_code, valid);
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
        $dumpvars(0,clk, input_data, reset, output_code, valid);
    end

endmodule
