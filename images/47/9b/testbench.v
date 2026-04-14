`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    reg [3:0] y;
    wire [3:0] A;
    wire [3:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .A(A),
        .B(B)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 4'd15; y = 4'd1;
            #1;

            check_outputs(4'd0, 4'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 4'd12; y = 4'd3;
            #1;

            check_outputs(4'd0, 4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 4'd13; y = 4'd4;
            #1;

            check_outputs(4'd1, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 4'd10; y = 4'd10;
            #1;

            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 4'd7; y = 4'd2;
            #1;

            check_outputs(4'd1, 4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 4'd5; y = 4'd8;
            #1;

            check_outputs(4'd5, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 4'd0; y = 4'd4;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 4'd14; y = 4'd3;
            #1;

            check_outputs(4'd2, 4'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            x = 4'd15; y = 4'd15;
            #1;

            check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            x = 4'd9; y = 4'd2;
            #1;

            check_outputs(4'd1, 4'd4);
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
        input [3:0] expected_A;
        input [3:0] expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: A=%h, B=%h",
                         A, B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h, B=%h",
                         expected_A, expected_B);
                $display("  Got:      A=%h, B=%h",
                         A, B);
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
