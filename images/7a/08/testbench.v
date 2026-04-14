`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg cin;
    wire carry;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero addition", test_num);
            a = 8'h00;
            b = 8'h00;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple addition no carry", test_num);
            a = 8'h05;
            b = 8'h0A;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry-in only", test_num);
            a = 8'h00;
            b = 8'h00;
            cin = 1'b1;
            #1;

            check_outputs(1'b0, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max sum without carry-out", test_num);
            a = 8'hFE;
            b = 8'h01;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition resulting in carry-out", test_num);
            a = 8'hFF;
            b = 8'h01;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with carry-in and carry-out", test_num);
            a = 8'hFF;
            b = 8'h00;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits", test_num);
            a = 8'hAA;
            b = 8'h55;
            cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits with carry-in", test_num);
            a = 8'hAA;
            b = 8'h55;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones plus carry-in", test_num);
            a = 8'hFF;
            b = 8'hFF;
            cin = 1'b1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large values addition", test_num);
            a = 8'h80;
            b = 8'h80;
            cin = 1'b0;
            #1;

            check_outputs(1'b1, 8'h00);
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
        input expected_carry;
        input [7:0] expected_sum;
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
