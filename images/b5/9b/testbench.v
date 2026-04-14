`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] Op;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Op(Op),
        .C(C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Positive + Positive)", test_num);
            A = 8'sd10;
            B = 8'sd20;
            Op = 2'b00;
            #1;

            check_outputs(8'sd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Positive + Negative)", test_num);
            A = 8'sd50;
            B = -8'sd10;
            Op = 2'b00;
            #1;

            check_outputs(8'sd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Positive - Positive)", test_num);
            A = 8'sd100;
            B = 8'sd30;
            Op = 2'b01;
            #1;

            check_outputs(8'sd70);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Negative - Negative)", test_num);
            A = -8'sd20;
            B = -8'sd5;
            Op = 2'b01;
            #1;

            check_outputs(-8'sd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (Small Positive)", test_num);
            A = 8'sd6;
            B = 8'sd7;
            Op = 2'b10;
            #1;

            check_outputs(8'sd42);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (Positive * Negative)", test_num);
            A = 8'sd4;
            B = -8'sd8;
            Op = 2'b10;
            #1;

            check_outputs(-8'sd32);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (Positive / Positive)", test_num);
            A = 8'sd80;
            B = 8'sd4;
            Op = 2'b11;
            #1;

            check_outputs(8'sd20);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (Negative / Positive)", test_num);
            A = -8'sd40;
            B = 8'sd5;
            Op = 2'b11;
            #1;

            check_outputs(-8'sd8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (Zero case)", test_num);
            A = 8'sd0;
            B = -8'sd128;
            Op = 2'b00;
            #1;

            check_outputs(-8'sd128);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (Zero case)", test_num);
            A = 8'sd55;
            B = 8'sd55;
            Op = 2'b01;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow Check (120 + 10 = 130 -> -126)", test_num);
            A = 8'sd120;
            B = 8'sd10;
            Op = 2'b00;
            #1;

            check_outputs(8'sh82);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication Overflow Check (20 * 10 = 200 -> -56)", test_num);
            A = 8'sd20;
            B = 8'sd10;
            Op = 2'b10;
            #1;

            check_outputs(8'shC8);
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
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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

endmodule
