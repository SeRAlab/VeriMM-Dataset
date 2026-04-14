`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg ctrl;
    wire [7:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .R(R)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'd10;
            B = 8'd5;
            ctrl = 1'b0;
            #10;
            $display("Testcase %0d: Unsigned Multiplication (10 * 5)", test_num);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'd2;
            ctrl = 1'b0;
            #10;
            $display("Testcase %0d: Unsigned Multiplication with Truncation (255 * 2)", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'd0;
            B = 8'hFF;
            ctrl = 1'b0;
            #10;
            $display("Testcase %0d: Multiplication by Zero (Unsigned)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'd10;
            B = 8'd5;
            ctrl = 1'b1;
            #10;
            $display("Testcase %0d: Signed Multiplication (Positive * Positive)", test_num);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'd5;
            ctrl = 1'b1;
            #10;
            $display("Testcase %0d: Signed Multiplication (Negative * Positive)", test_num);
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'hFE;
            B = 8'hFD;
            ctrl = 1'b1;
            #10;
            $display("Testcase %0d: Signed Multiplication (Negative * Negative)", test_num);
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'h80;
            B = 8'h01;
            ctrl = 1'b1;
            #10;
            $display("Testcase %0d: Signed Multiplication (Min Signed * 1)", test_num);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'h7F;
            B = 8'h02;
            ctrl = 1'b1;
            #10;
            $display("Testcase %0d: Signed Multiplication with Overflow Truncation", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'd16;
            B = 8'd16;
            ctrl = 1'b0;
            #10;
            $display("Testcase %0d: Unsigned Multiplication Resulting in exact Power of 2 (Truncated)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'hFF;
            ctrl = 1'b1;
            #10;
            $display("Testcase %0d: Signed Multiplication (-1 * -1)", test_num);
            #1;

            check_outputs(8'h01);
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
        input [7:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: R=%h",
                         R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h",
                         expected_R);
                $display("  Got:      R=%h",
                         R);
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
