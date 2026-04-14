`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] a;
    reg [8:0] b;
    wire [11:0] sum_ab;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sum_ab(sum_ab)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Zero Addition");
        a = 9'd0;
        b = 9'd0;
        #10;
        #1;

        check_outputs(12'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Minimum Non-Zero Addition");
        a = 9'd1;
        b = 9'd1;
        #10;
        #1;

        check_outputs(12'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Maximum 9-bit Addition");
        a = 9'h1FF;
        b = 9'h1FF;
        #10;
        #1;

        check_outputs(12'd1022);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Boundary Carry Addition");
        a = 9'd511;
        b = 9'd1;
        #10;
        #1;

        check_outputs(12'd512);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Alternating Bit Patterns");
        a = 9'b101010101;
        b = 9'b010101010;
        #10;
        #1;

        check_outputs(12'd511);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Middle Range Addition");
        a = 9'd128;
        b = 9'd128;
        #10;
        #1;

        check_outputs(12'd256);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Random Value Addition");
        a = 9'd250;
        b = 9'd150;
        #10;
        #1;

        check_outputs(12'd400);
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
        input [11:0] expected_sum_ab;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum_ab === (expected_sum_ab ^ sum_ab ^ expected_sum_ab)) begin
                $display("PASS");
                $display("  Outputs: sum_ab=%h",
                         sum_ab);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum_ab=%h",
                         expected_sum_ab);
                $display("  Got:      sum_ab=%h",
                         sum_ab);
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
