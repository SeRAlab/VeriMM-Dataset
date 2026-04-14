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
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive * Positive (3 * 5)", test_num);
            reset_dut();
            A = 8'sd3; B = 8'sd5;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h0F00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative * Positive (-3 * 5)", test_num);
            reset_dut();
            A = -8'sd3; B = 8'sd5;
            @(posedge clk);
            #2 #1;
 check_outputs(16'hF100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive * Negative (4 * -6)", test_num);
            reset_dut();
            A = 8'sd4; B = -8'sd6;
            @(posedge clk);
            #2 #1;
 check_outputs(16'hE800);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative * Negative (-10 * -2)", test_num);
            reset_dut();
            A = -8'sd10; B = -8'sd2;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h1400);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication by Zero (0 * 127)", test_num);
            reset_dut();
            A = 8'sd0; B = 8'sd127;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication by -1 (10 * -1)", test_num);
            reset_dut();
            A = 8'sd10; B = -8'sd1;
            @(posedge clk);
            #2 #1;
 check_outputs(16'hF600);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Negative Input (-128 * 1)", test_num);
            reset_dut();
            A = -8'sd128; B = 8'sd1;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h8000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Smallest Inputs (1 * 1)", test_num);
            reset_dut();
            A = 8'sd1; B = 8'sd1;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h0100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Positive (127 * 1)", test_num);
            reset_dut();
            A = 8'sd127; B = 8'sd1;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h7F00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Overflow (16 * 16)", test_num);
            reset_dut();
            A = 8'sd16; B = 8'sd16;
            @(posedge clk);
            #2 #1;
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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
