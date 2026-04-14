`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg reset;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Multiplication (12 * 9)");
            reset_dut();
            A = 8'd12;
            B = 8'd9;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd108);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Multiplication by Zero");
            reset_dut();
            A = 8'd255;
            B = 8'd0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Multiplication by One");
            reset_dut();
            A = 8'd1;
            B = 8'd127;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd127);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Maximum Values (255 * 255)");
            reset_dut();
            A = 8'hFF;
            B = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Power of Two (128 * 2)");
            reset_dut();
            A = 8'd128;
            B = 8'd2;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Reset mid-operation");
            reset_dut();
            A = 8'd50;
            B = 8'd2;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0);
            reset = 0;
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
        input [15:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, clk, reset, P);
    end

endmodule
