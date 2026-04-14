`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    wire [3:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'd0;
            #10;
            $display("Test %0d: Input A = %d (Expected A*3 = 0)", test_num, A);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'd1;
            #10;
            $display("Test %0d: Input A = %d (Expected A*3 = 3)", test_num, A);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'd2;
            #10;
            $display("Test %0d: Input A = %d (Expected A*3 = 6)", test_num, A);
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'd5;
            #10;
            $display("Test %0d: Input A = %d (Expected A*3 = 15)", test_num, A);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'd6;
            #10;
            $display("Test %0d: Input A = %d (Expected A*3 = 18, 4-bit result = 2)", test_num, A);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'd8;
            #10;
            $display("Test %0d: Input A = %d (Expected A*3 = 24, 4-bit result = 8)", test_num, A);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'd10;
            #10;
            $display("Test %0d: Input A = %d (Expected A*3 = 30, 4-bit result = 14)", test_num, A);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'd15;
            #10;
            $display("Test %0d: Input A = %d (Expected A*3 = 45, 4-bit result = 13)", test_num, A);
            #1;

            check_outputs(4'd13);
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
        input [3:0] expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%h",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h",
                         expected_B);
                $display("  Got:      B=%h",
                         B);
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
