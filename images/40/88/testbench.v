`timescale 1ns/1ps

module IIR_Filter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] X;
    reg clk;
    reg rst;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IIR_Filter dut (
        .X(X),
        .clk(clk),
        .rst(rst),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            X = 16'd0;
            @(posedge clk);
            #1;
            rst = 0;
            $display("DUT Reset at time %0t", $time);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Zero Input");
            reset_dut();
            X = 16'h0000;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Impulse Response");
            reset_dut();
            X = 16'h0001; @(posedge clk);
            X = 16'h0000; @(posedge clk);
            X = 16'h0000; @(posedge clk);
            X = 16'h0000; @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Step Response (X=2)");
            reset_dut();
            X = 16'h0002;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000C);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Scaling Test (X=10)");
            reset_dut();
            X = 16'h000A;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h001E);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Mid-operation Reset");
            reset_dut();
            X = 16'h00FF;
            repeat(3) @(posedge clk);
            reset_dut();
            X = 16'h0000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IIR_Filter Testbench");
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
        input [15:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,X, clk, rst, Y);
    end

endmodule
