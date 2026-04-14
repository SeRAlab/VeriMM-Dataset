`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire out_equal;
    wire out_greater;
    wire out_less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .out_equal(out_equal),
        .out_greater(out_greater),
        .out_less(out_less)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=0 (Equal)", test_num);
            A = 4'd0;
            B = 4'd0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=15, B=15 (Equal Max)", test_num);
            A = 4'd15;
            B = 4'd15;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=1, B=0 (Greater)", test_num);
            A = 4'd1;
            B = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=15, B=0 (Greater Max/Min)", test_num);
            A = 4'd15;
            B = 4'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=1 (Less)", test_num);
            A = 4'd0;
            B = 4'd1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=15 (Less Min/Max)", test_num);
            A = 4'd0;
            B = 4'd15;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=10, B=5 (Greater Mid)", test_num);
            A = 4'd10;
            B = 4'd5;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=7, B=8 (Less Mid boundary)", test_num);
            A = 4'd7;
            B = 4'd8;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=5, B=5 (Equal Mid)", test_num);
            A = 4'd5;
            B = 4'd5;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=8, B=7 (Greater Mid boundary)", test_num);
            A = 4'd8;
            B = 4'd7;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_out_equal;
        input expected_out_greater;
        input expected_out_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_equal === (expected_out_equal ^ out_equal ^ expected_out_equal) &&
                expected_out_greater === (expected_out_greater ^ out_greater ^ expected_out_greater) &&
                expected_out_less === (expected_out_less ^ out_less ^ expected_out_less)) begin
                $display("PASS");
                $display("  Outputs: out_equal=%b, out_greater=%b, out_less=%b",
                         out_equal, out_greater, out_less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_equal=%b, out_greater=%b, out_less=%b",
                         expected_out_equal, expected_out_greater, expected_out_less);
                $display("  Got:      out_equal=%b, out_greater=%b, out_less=%b",
                         out_equal, out_greater, out_less);
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
