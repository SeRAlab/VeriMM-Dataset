`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire data_out;
    wire [3:0] run_length;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .run_length(run_length),
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
        data_in = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test Case 001: Run of three 0s");
        @(posedge clk); #1 data_in = 0;
        @(posedge clk); #1 data_in = 0;
        @(posedge clk); #1 data_in = 0;
        @(posedge clk); #1 data_in = 1;
        @(posedge clk); #1;
        #1;

        check_outputs(1'b0, 4'd3, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test Case 002: Run of five 1s");
        @(posedge clk); #1 data_in = 1;
        @(posedge clk); #1 data_in = 1;
        @(posedge clk); #1 data_in = 1;
        @(posedge clk); #1 data_in = 1;
        @(posedge clk); #1 data_in = 1;
        @(posedge clk); #1 data_in = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(1'b1, 4'd5, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test Case 003: Run of single 0");
        @(posedge clk); #1 data_in = 0;
        @(posedge clk); #1 data_in = 1;
        @(posedge clk); #1;
        #1;

        check_outputs(1'b0, 4'd1, 1'b1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        reset_dut();
        $display("Test Case 004: Max run length (15)");
        for(i=0; i<15; i=i+1) begin
            @(posedge clk); #1 data_in = 1;
        end
        @(posedge clk); #1 data_in = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(1'b1, 4'd15, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Test Case 005: Valid low during active run");
        @(posedge clk); #1 data_in = 0;
        @(posedge clk); #1 data_in = 0;
        @(posedge clk); #1 data_in = 0;

        #1;


        check_outputs(data_out, run_length, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input expected_data_out;
        input [3:0] expected_run_length;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, run_length=%h, valid=%b",
                         data_out, run_length, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, run_length=%h, valid=%b",
                         expected_data_out, expected_run_length, expected_valid);
                $display("  Got:      data_out=%b, run_length=%h, valid=%b",
                         data_out, run_length, valid);
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
        $dumpvars(0,clk, data_in, reset, data_out, run_length, valid);
    end

endmodule
