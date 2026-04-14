`timescale 1ns/1ps

module adder_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg enable;
    reg reset;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_module dut (
        .a(a),
        .b(b),
        .enable(enable),
        .reset(reset),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Priority - Sum should be 0 when reset is high regardless of enable", test_num);
            reset = 1;
            enable = 1;
            a = 4'd5;
            b = 4'd3;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition - 4 + 5 = 9", test_num);
            reset = 1;
            #10 reset = 0;
            enable = 1;
            a = 4'd4;
            b = 4'd5;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Functionality - Sum should not update when enable is low", test_num);
            reset = 1;
            #10 reset = 0;
            enable = 0;
            a = 4'd2;
            b = 4'd2;

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 4-bit Overflow - 10 + 10 = 20 (truncated to 4 bits is 4)", test_num);
            reset = 1;
            #10 reset = 0;
            enable = 1;
            a = 4'd10;
            b = 4'd10;

            #1;


            check_outputs(4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Range Addition - 7 + 8 = 15", test_num);
            reset = 1;
            #10 reset = 0;
            enable = 1;
            a = 4'd7;
            b = 4'd8;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset mid-operation", test_num);
            reset = 1;
            #10 reset = 0;
            enable = 1;
            a = 4'd3;
            b = 4'd3;
            #5;
            reset = 1;
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
        $display("adder_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
