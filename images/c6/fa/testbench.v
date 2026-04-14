`timescale 1ns/1ps

module adder_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_module dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Zero Addition", test_num);
            a = 8'd0;
            b = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Small Values", test_num);
            a = 8'd10;
            b = 8'd25;
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Maximum value without overflow", test_num);
            a = 8'd128;
            b = 8'd127;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Simple Overflow (wrap around)", test_num);
            a = 8'hFF;
            b = 8'h01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Max values addition (wrap around)", test_num);
            a = 8'hFF;
            b = 8'hFF;

            #1;


            check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Pattern addition 0xAA + 0x55", test_num);
            a = 8'hAA;
            b = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Commutative Property Check", test_num);
            a = 8'd45;
            b = 8'd100;
            #1;

            check_outputs(8'd145);
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
        testcase007();
        
        
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
        input [7:0] expected_sum;
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
