`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    reg clk;
    wire CF;
    wire OF;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .clk(clk),
        .CF(CF),
        .OF(OF),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'b0;
            B = 4'b0;
            C = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Addition (2 + 3)");
            reset_dut();
            A = 4'd2; B = 4'd3; C = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Addition with Positive Overflow (7 + 1)");
            reset_dut();
            A = 4'b0111; B = 4'b0001; C = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 4'b1000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Addition with Carry (10 + 10)");
            reset_dut();
            A = 4'd10; B = 4'd10; C = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 4'd4);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Basic Subtraction (5 - 2)");
            reset_dut();
            A = 4'd5; B = 4'd2; C = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 4'd3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Subtraction Negative Result (2 - 5)");
            reset_dut();
            A = 4'd2; B = 4'd5; C = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 4'd13);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Subtraction Positive Overflow (7 - (-1))");
            reset_dut();
            A = 4'b0111; B = 4'b1111; C = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 4'b1000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Subtraction Negative Overflow (-8 - 1)");
            reset_dut();
            A = 4'b1000; B = 4'b0001; C = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 4'b0111);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Negative Addition (-4 + -4)");
            reset_dut();
            A = 4'b1100; B = 4'b1100; C = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 4'b1000);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Zero Subtraction (0 - 0)");
            reset_dut();
            A = 4'b0000; B = 4'b0000; C = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 4'b0000);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Boundary Addition (7 + -8)");
            reset_dut();
            A = 4'b0111; B = 4'b1000; C = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 4'b1111);
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
        input expected_CF;
        input expected_OF;
        input [3:0] expected_S;
        begin
            if (expected_CF === (expected_CF ^ CF ^ expected_CF) &&
                expected_OF === (expected_OF ^ OF ^ expected_OF) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: CF=%b, OF=%b, S=%h",
                         CF, OF, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CF=%b, OF=%b, S=%h",
                         expected_CF, expected_OF, expected_S);
                $display("  Got:      CF=%b, OF=%b, S=%h",
                         CF, OF, S);
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
        $dumpvars(0,A, B, C, clk, CF, OF, S);
    end

endmodule
