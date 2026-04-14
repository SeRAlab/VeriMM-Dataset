`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] input_data;
    reg reset;
    wire [31:0] shifted_data;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_data(input_data),
        .reset(reset),
        .shifted_data(shifted_data),
        .zero_flag(zero_flag)
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
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        input_data = 32'h0000_0001;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000_0002, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        input_data = 32'h0000_0000;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000_0000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        input_data = 32'h8000_0000;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0000_0000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        input_data = 32'hFFFF_FFFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hFFFF_FFFE, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        input_data = 32'h5555_5555;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hAAAA_AAAA, 1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        input_data = 32'h1234_5678;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h2468_ACF0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        input_data = 32'h4000_0000;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h8000_0000, 1'b0);
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
        input [31:0] expected_shifted_data;
        input expected_zero_flag;
        begin
            if (expected_shifted_data === (expected_shifted_data ^ shifted_data ^ expected_shifted_data) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: shifted_data=%h, zero_flag=%b",
                         shifted_data, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shifted_data=%h, zero_flag=%b",
                         expected_shifted_data, expected_zero_flag);
                $display("  Got:      shifted_data=%h, zero_flag=%b",
                         shifted_data, zero_flag);
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
        $dumpvars(0,clk, input_data, reset, shifted_data, zero_flag);
    end

endmodule
