`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg gen_grant_carry_c;
    reg gen_grant_carry_p;
    reg gen_grant_carry_r;
    wire [1:0] gen_grant_carry;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .gen_grant_carry_c(gen_grant_carry_c),
        .gen_grant_carry_p(gen_grant_carry_p),
        .gen_grant_carry_r(gen_grant_carry_r),
        .gen_grant_carry(gen_grant_carry)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs zero", test_num);
        gen_grant_carry_c = 0;
        gen_grant_carry_r = 0;
        gen_grant_carry_p = 0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Enable all (c, r, p = 1)", test_num);
        gen_grant_carry_c = 1;
        gen_grant_carry_r = 1;
        gen_grant_carry_p = 1;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Priority high, Reset-gen high, Carry-gen low", test_num);
        gen_grant_carry_c = 0;
        gen_grant_carry_r = 1;
        gen_grant_carry_p = 1;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Priority high, Reset-gen low, Carry-gen high", test_num);
        gen_grant_carry_c = 1;
        gen_grant_carry_r = 0;
        gen_grant_carry_p = 1;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Priority low, Generate signals high (Carry should not propagate)", test_num);
        gen_grant_carry_c = 1;
        gen_grant_carry_r = 1;
        gen_grant_carry_p = 0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Only Carry-gen high (Priority low)", test_num);
        gen_grant_carry_c = 1;
        gen_grant_carry_r = 0;
        gen_grant_carry_p = 0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Only Reset-gen high (Priority low)", test_num);
        gen_grant_carry_c = 0;
        gen_grant_carry_r = 1;
        gen_grant_carry_p = 0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Only Priority high", test_num);
        gen_grant_carry_c = 0;
        gen_grant_carry_r = 0;
        gen_grant_carry_p = 1;
        #1;

        check_outputs(2'b00);
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
        input [1:0] expected_gen_grant_carry;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gen_grant_carry === (expected_gen_grant_carry ^ gen_grant_carry ^ expected_gen_grant_carry)) begin
                $display("PASS");
                $display("  Outputs: gen_grant_carry=%h",
                         gen_grant_carry);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gen_grant_carry=%h",
                         expected_gen_grant_carry);
                $display("  Got:      gen_grant_carry=%h",
                         gen_grant_carry);
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
