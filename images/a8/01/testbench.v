`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    wire [15:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 8'd0;
            B = 8'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            A = 8'd10;
            B = 8'd5;
            @(posedge clk);
            #1;
            expected_shadow = 16'd50;
            $display("Testcase 001: Basic Multiplication (10 * 5)");
            #1;

            check_outputs(expected_shadow);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            A = 8'd4;
            B = 8'd5;
            @(posedge clk);
            #1;
            expected_shadow = 16'd70;
            $display("Testcase 002: Secondary Accumulation (Prev + 4 * 5)");
            #1;

            check_outputs(expected_shadow);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            A = 8'd0;
            B = 8'd255;
            @(posedge clk);
            #1;
            expected_shadow = 16'd70;
            $display("Testcase 003: Zero Multiply (Prev + 0 * 255)");
            #1;

            check_outputs(expected_shadow);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            A = 8'd255;
            B = 8'd1;
            @(posedge clk);
            #1;
            expected_shadow = 16'd325;
            $display("Testcase 004: Boundary Check (Prev + 255 * 1)");
            #1;

            check_outputs(expected_shadow);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            A = 8'd255;
            B = 8'd255;
            @(posedge clk);
            #1;
            expected_shadow = 16'd65350;
            $display("Testcase 005: Large Accumulation (Prev + 255 * 255)");
            #1;

            check_outputs(expected_shadow);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            A = 8'd10;
            B = 8'd100;
            @(posedge clk);
            #1;
            expected_shadow = 16'd814;
            $display("Testcase 006: 16-bit Overflow Handling");
            #1;

            check_outputs(expected_shadow);
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
        input [15:0] expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
        $dumpvars(0,A, B, clk, Z);
    end

endmodule
