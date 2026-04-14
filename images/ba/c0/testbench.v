`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [1:0] B;
    wire [2:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 2'd0;
            $display("Test %0d: A=%d, B=%d (A > 7 condition)", test_num, A, B);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 2'd3;
            $display("Test %0d: A=%d, B=%d (A > 7 condition)", test_num, A, B);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 2'd0;

            $display("Test %0d: A=%d, B=%d (Concatenation logic)", test_num, A, B);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd1;
            B = 2'd2;

            $display("Test %0d: A=%d, B=%d (Concatenation logic)", test_num, A, B);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd2;
            B = 2'd1;

            $display("Test %0d: A=%d, B=%d (Concatenation logic)", test_num, A, B);
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd3;
            B = 2'd3;

            $display("Test %0d: A=%d, B=%d (Concatenation logic)", test_num, A, B);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd4;
            B = 2'd0;

            $display("Test %0d: A=%d, B=%d (Concatenation logic)", test_num, A, B);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd5;
            B = 2'd1;

            $display("Test %0d: A=%d, B=%d (Concatenation logic)", test_num, A, B);
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'd6;
            B = 2'd2;

            $display("Test %0d: A=%d, B=%d (Concatenation logic)", test_num, A, B);
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'd7;
            B = 2'd0;

            $display("Test %0d: A=%d, B=%d (Concatenation logic)", test_num, A, B);
            #1;

            check_outputs(3'd3);
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
        input [2:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
