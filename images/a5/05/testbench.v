`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    reg reset;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .reset(reset),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset logic check", test_num);
            reset = 1;
            a = 4'd5;
            b = 4'd5;
            cin = 1'b1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic addition (no carry-in, no overflow)", test_num);
            reset = 1; #5;
            reset = 0;
            a = 4'd3;
            b = 4'd4;
            cin = 1'b0;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with carry-in", test_num);
            reset = 1; #5;
            reset = 0;
            a = 4'd2;
            b = 4'd2;
            cin = 1'b1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with overflow (sum > 15)", test_num);
            reset = 1; #5;
            reset = 0;
            a = 4'd10;
            b = 4'd10;
            cin = 1'b0;

            #1;


            check_outputs(4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum values with carry-in", test_num);
            reset = 1; #5;
            reset = 0;
            a = 4'd15;
            b = 4'd15;
            cin = 1'b1;

            #1;


            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero addition", test_num);
            reset = 1; #5;
            reset = 0;
            a = 4'd0;
            b = 4'd0;
            cin = 1'b0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Only carry-in bit", test_num);
            reset = 1; #5;
            reset = 0;
            a = 4'd0;
            b = 4'd0;
            cin = 1'b1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition resulting in exactly 16", test_num);
            reset = 1; #5;
            reset = 0;
            a = 4'd8;
            b = 4'd7;
            cin = 1'b1;

            #1;


            check_outputs(4'd0);
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
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
