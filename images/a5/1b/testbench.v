`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] instr_mul;
    reg [7:0] instr_mulh;
    reg [7:0] instr_mulhsu;
    reg [7:0] instr_mulhu;
    wire instr_any_mul;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr_mul(instr_mul),
        .instr_mulh(instr_mulh),
        .instr_mulhsu(instr_mulhsu),
        .instr_mulhu(instr_mulhu),
        .instr_any_mul(instr_any_mul)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: All inputs zero", test_num);
        instr_mul    = 8'h00;
        instr_mulh   = 8'h00;
        instr_mulhsu = 8'h00;
        instr_mulhu  = 8'h00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: instr_mul non-zero", test_num);
        instr_mul    = 8'h01;
        instr_mulh   = 8'h00;
        instr_mulhsu = 8'h00;
        instr_mulhu  = 8'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: instr_mulh non-zero", test_num);
        instr_mul    = 8'h00;
        instr_mulh   = 8'h80;
        instr_mulhsu = 8'h00;
        instr_mulhu  = 8'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: instr_mulhsu non-zero", test_num);
        instr_mul    = 8'h00;
        instr_mulh   = 8'h00;
        instr_mulhsu = 8'h10;
        instr_mulhu  = 8'h00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: instr_mulhu non-zero", test_num);
        instr_mul    = 8'h00;
        instr_mulh   = 8'h00;
        instr_mulhsu = 8'h00;
        instr_mulhu  = 8'hFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: Multiple non-zero inputs", test_num);
        instr_mul    = 8'hAA;
        instr_mulh   = 8'h55;
        instr_mulhsu = 8'h00;
        instr_mulhu  = 8'h01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running Testcase %0d: All inputs 0xFF", test_num);
        instr_mul    = 8'hFF;
        instr_mulh   = 8'hFF;
        instr_mulhsu = 8'hFF;
        instr_mulhu  = 8'hFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Running Testcase %0d: Sparse bits", test_num);
        instr_mul    = 8'h02;
        instr_mulh   = 8'h04;
        instr_mulhsu = 8'h08;
        instr_mulhu  = 8'h10;
        #1;

        check_outputs(1'b1);
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
        input expected_instr_any_mul;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_instr_any_mul === (expected_instr_any_mul ^ instr_any_mul ^ expected_instr_any_mul)) begin
                $display("PASS");
                $display("  Outputs: instr_any_mul=%b",
                         instr_any_mul);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instr_any_mul=%b",
                         expected_instr_any_mul);
                $display("  Got:      instr_any_mul=%b",
                         instr_any_mul);
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
