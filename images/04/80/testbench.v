`timescale 1ns/1ps

module RLE_Compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] sample_in;
    wire [7:0] run_length;
    wire [7:0] sample_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE_Compressor dut (
        .clk(clk),
        .reset(reset),
        .sample_in(sample_in),
        .run_length(run_length),
        .sample_out(sample_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        sample_in = 8'h00;
        @(posedge clk);
        #1;
        reset = 0;

    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: 5 consecutive identical samples (0xA5)", test_num);
        reset_dut();
        sample_in = 8'hA5;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd5, 8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single sample (0x12)", test_num);
        reset_dut();
        sample_in = 8'h12;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd1, 8'h12);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Transition from 0xAA to 0xBB", test_num);
        reset_dut();
        sample_in = 8'hAA;
        repeat(3) @(posedge clk);
        sample_in = 8'hBB;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd1, 8'hBB);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: 10 consecutive identical samples (0xFF)", test_num);
        reset_dut();
        sample_in = 8'hFF;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd10, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Multiple sample transitions (AA->BB->CC)", test_num);
        reset_dut();
        sample_in = 8'hAA;
        repeat(2) @(posedge clk);
        sample_in = 8'hBB;
        repeat(2) @(posedge clk);
        sample_in = 8'hCC;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd2, 8'hCC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE_Compressor Testbench");
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
        input [7:0] expected_run_length;
        input [7:0] expected_sample_out;
        begin
            if (expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_sample_out === (expected_sample_out ^ sample_out ^ expected_sample_out)) begin
                $display("PASS");
                $display("  Outputs: run_length=%h, sample_out=%h",
                         run_length, sample_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: run_length=%h, sample_out=%h",
                         expected_run_length, expected_sample_out);
                $display("  Got:      run_length=%h, sample_out=%h",
                         run_length, sample_out);
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
        $dumpvars(0,clk, reset, sample_in, run_length, sample_out);
    end

endmodule
