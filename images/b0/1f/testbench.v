`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg en;
    wire carry;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .en(en),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic addition (3 + 4), Enable ON", test_num);
            en = 1'b1;
            a = 4'd3;
            b = 4'd4;
            #1;

            check_outputs(1'b0, 4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Output gating (Inputs present, Enable OFF)", test_num);
            en = 1'b0;
            a = 4'hF;
            b = 4'hF;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Carry generation (8 + 8), Enable ON", test_num);
            en = 1'b1;
            a = 4'd8;
            b = 4'd8;

            #1;


            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Maximum values (15 + 15), Enable ON", test_num);
            en = 1'b1;
            a = 4'hF;
            b = 4'hF;

            #1;


            check_outputs(1'b1, 4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Ripple carry through all bits (15 + 1), Enable ON", test_num);
            en = 1'b1;
            a = 4'b1111;
            b = 4'b0001;

            #1;


            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Zero inputs, Enable ON", test_num);
            en = 1'b1;
            a = 4'd0;
            b = 4'd0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Toggle Enable with persistent inputs (5 + 5)", test_num);
            a = 4'd5;
            b = 4'd5;


            en = 1'b0;
            #5;


            en = 1'b1;

            #1;


            check_outputs(1'b0, 4'hA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Large sum, no carry (7 + 8), Enable ON", test_num);
            en = 1'b1;
            a = 4'd7;
            b = 4'd8;

            #1;


            check_outputs(1'b0, 4'hF);
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
        input expected_carry;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, sum=%h",
                         carry, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, sum=%h",
                         expected_carry, expected_sum);
                $display("  Got:      carry=%b, sum=%h",
                         carry, sum);
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
