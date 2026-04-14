`timescale 1ns/1ps

module DWT_Haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg valid_in;
    wire [15:0] approx_out;
    wire [15:0] detail_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT_Haar dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
        .approx_out(approx_out),
        .detail_out(detail_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid_in = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Positive Integers (20, 40)...");
            reset_dut();
            @(posedge clk);
            data_in = 16'sd20;
            valid_in = 1'b1;
            @(posedge clk);
            data_in = 16'sd40;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;

            wait(valid_out == 1'b1);
            #1 #1;
 check_outputs(16'sd30, -16'sd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Negative Signed Integers (-50, -150)...");
            reset_dut();
            @(posedge clk);
            data_in = -16'sd50;
            valid_in = 1'b1;
            @(posedge clk);
            data_in = -16'sd150;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;

            wait(valid_out == 1'b1);
            #1 #1;
 check_outputs(-16'sd100, 16'sd50, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Identical Values (1000, 1000)...");
            reset_dut();
            @(posedge clk);
            data_in = 16'sd1000;
            valid_in = 1'b1;
            @(posedge clk);
            data_in = 16'sd1000;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;

            wait(valid_out == 1'b1);
            #1 #1;
 check_outputs(16'sd1000, 16'sd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Zero and Positive (0, 100)...");
            reset_dut();
            @(posedge clk);
            data_in = 16'sd0;
            valid_in = 1'b1;
            @(posedge clk);
            data_in = 16'sd100;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;

            wait(valid_out == 1'b1);
            #1 #1;
 check_outputs(16'sd50, -16'sd50, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Large Signed Range (32766, -32766)...");
            reset_dut();
            @(posedge clk);
            data_in = 16'sd32766;
            valid_in = 1'b1;
            @(posedge clk);
            data_in = -16'sd32766;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;

            wait(valid_out == 1'b1);
            #1 #1;
 check_outputs(16'sd0, 16'sd32766, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Truncation Check (10, 11)...");
            reset_dut();
            @(posedge clk);
            data_in = 16'sd10;
            valid_in = 1'b1;
            @(posedge clk);
            data_in = 16'sd11;
            valid_in = 1'b1;
            @(posedge clk);
            valid_in = 1'b0;

            wait(valid_out == 1'b1);
            #1 #1;
 check_outputs(16'sd10, -16'sd1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT_Haar Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_approx_out;
        input [15:0] expected_detail_out;
        input expected_valid_out;
        begin
            if (expected_approx_out === (expected_approx_out ^ approx_out ^ expected_approx_out) &&
                expected_detail_out === (expected_detail_out ^ detail_out ^ expected_detail_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: approx_out=%h, detail_out=%h, valid_out=%b",
                         approx_out, detail_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx_out=%h, detail_out=%h, valid_out=%b",
                         expected_approx_out, expected_detail_out, expected_valid_out);
                $display("  Got:      approx_out=%h, detail_out=%h, valid_out=%b",
                         approx_out, detail_out, valid_out);
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
        $dumpvars(0,clk, data_in, reset, valid_in, approx_out, detail_out, valid_out);
    end

endmodule
