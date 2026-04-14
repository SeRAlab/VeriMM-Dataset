`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg A_SIGNED;
    reg [31:0] B;
    reg B_SIGNED;
    wire [31:0] R;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .A_SIGNED(A_SIGNED),
        .B(B),
        .B_SIGNED(B_SIGNED),
        .R(R),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unsigned simple division (100 / 7)", test_num);
            A = 32'd100;
            B = 32'd7;
            A_SIGNED = 1'b0;
            B_SIGNED = 1'b0;

            #1;


            check_outputs(32'h2, 32'hE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unsigned large number (0xFFFFFFFF / 2)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h2;
            A_SIGNED = 1'b0;
            B_SIGNED = 1'b0;

            #1;


            check_outputs(32'h1, 32'h7FFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed positive / positive (20 / 3)", test_num);
            A = 32'sd20;
            B = 32'sd3;
            A_SIGNED = 1'b1;
            B_SIGNED = 1'b1;

            #1;


            check_outputs(32'sd2, 32'sd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed negative / positive (-20 / 3)", test_num);
            A = -32'sd20;
            B = 32'sd3;
            A_SIGNED = 1'b1;
            B_SIGNED = 1'b1;

            #1;


            check_outputs(-32'sd2, -32'sd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed positive / negative (20 / -3)", test_num);
            A = 32'sd20;
            B = -32'sd3;
            A_SIGNED = 1'b1;
            B_SIGNED = 1'b1;

            #1;


            check_outputs(32'sd2, -32'sd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed negative / negative (-20 / -3)", test_num);
            A = -32'sd20;
            B = -32'sd3;
            A_SIGNED = 1'b1;
            B_SIGNED = 1'b1;

            #1;


            check_outputs(-32'sd2, 32'sd6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed signed flags (A signed -10, B unsigned 3)", test_num);
            A = -32'sd10;
            B = 32'd3;
            A_SIGNED = 1'b1;
            B_SIGNED = 1'b0;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFD);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dividend smaller than divisor (5 / 10)", test_num);
            A = 32'd5;
            B = 32'd10;
            A_SIGNED = 1'b0;
            B_SIGNED = 1'b0;

            #1;


            check_outputs(32'd5, 32'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division by 1", test_num);
            A = 32'hA5A5A5A5;
            B = 32'd1;
            A_SIGNED = 1'b0;
            B_SIGNED = 1'b0;

            #1;


            check_outputs(32'd0, 32'hA5A5A5A5);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Dividend (0 / 50)", test_num);
            A = 32'd0;
            B = 32'd50;
            A_SIGNED = 1'b1;
            B_SIGNED = 1'b1;

            #1;


            check_outputs(32'd0, 32'd0);
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
        input [31:0] expected_R;
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_R === (expected_R ^ R ^ expected_R) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: R=%h, Y=%h",
                         R, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h, Y=%h",
                         expected_R, expected_Y);
                $display("  Got:      R=%h, Y=%h",
                         R, Y);
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
