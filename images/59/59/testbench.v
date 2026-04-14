`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    wire [1:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in0 = 4'd0;
            in1 = 4'd0;
            $display("\nTest Case %0d: Equality at zero (0, 0)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in0 = 4'd15;
            in1 = 4'd15;
            $display("\nTest Case %0d: Equality at maximum (15, 15)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in0 = 4'd1;
            in1 = 4'd0;
            $display("\nTest Case %0d: in0 > in1 (1, 0)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in0 = 4'd0;
            in1 = 4'd1;
            $display("\nTest Case %0d: in0 < in1 (0, 1)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in0 = 4'b1000;
            in1 = 4'b0111;
            $display("\nTest Case %0d: in0 > in1 (8, 7)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in0 = 4'b0111;
            in1 = 4'b1000;
            $display("\nTest Case %0d: in0 < in1 (7, 8)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in0 = 4'd15;
            in1 = 4'd0;
            $display("\nTest Case %0d: Max vs Min (15, 0)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in0 = 4'd0;
            in1 = 4'd15;
            $display("\nTest Case %0d: Min vs Max (0, 15)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            in0 = 4'd7;
            in1 = 4'd7;
            $display("\nTest Case %0d: Middle equality (7, 7)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            in0 = 4'b1010;
            in1 = 4'b0101;
            $display("\nTest Case %0d: Alternating bits (10, 5)", test_num);
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
