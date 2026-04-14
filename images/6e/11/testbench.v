`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] Remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Remainder(Remainder)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 32'd10;
            B = 32'd3;
            $display("Test %0d: Basic Remainder (10 %% 3)", test_num);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 32'd20;
            B = 32'd5;
            $display("Test %0d: Zero Remainder (20 %% 5)", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 32'd7;
            B = 32'd15;
            $display("Test %0d: A < B (7 %% 15)", test_num);
            #1;

            check_outputs(32'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 32'd0;
            B = 32'd100;
            $display("Test %0d: A is Zero (0 %% 100)", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 32'd12345;
            B = 32'd1;
            $display("Test %0d: B is One (12345 %% 1)", test_num);
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            B = 32'd10;
            $display("Test %0d: Max A with Small B (MaxInt %% 10)", test_num);
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFE;
            $display("Test %0d: Max A with (MaxA - 1)", test_num);
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 32'd12345678;
            B = 32'd123;
            $display("Test %0d: Large Numbers (12345678 %% 123)", test_num);

            #1;


            check_outputs(32'd45);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 32'hA0000000;
            B = 32'h0000000F;
            $display("Test %0d: Large A and power of 2 compatible B", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 32'd1000000;
            B = 32'd3;
            $display("Test %0d: Large A with Prime B", test_num);
            #1;

            check_outputs(32'd1);
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
        input [31:0] expected_Remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Remainder === (expected_Remainder ^ Remainder ^ expected_Remainder)) begin
                $display("PASS");
                $display("  Outputs: Remainder=%h",
                         Remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Remainder=%h",
                         expected_Remainder);
                $display("  Got:      Remainder=%h",
                         Remainder);
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
