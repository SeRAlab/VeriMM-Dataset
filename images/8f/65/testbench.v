`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire p_pos;
    wire p_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .p_pos(p_pos),
        .p_sop(p_sop)
    );
    task testcase001;

    begin
        {a, b, c, d} = 4'd0;
        $display("Testcase 001: Input = 0 (0000)");
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        {a, b, c, d} = 4'd1;
        $display("Testcase 002: Input = 1 (0001)");
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        {a, b, c, d} = 4'd2;
        $display("Testcase 003: Input = 2 (0010)");
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        {a, b, c, d} = 4'd3;
        $display("Testcase 004: Input = 3 (0011)");
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        {a, b, c, d} = 4'd4;
        $display("Testcase 005: Input = 4 (0100)");
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        {a, b, c, d} = 4'd7;
        $display("Testcase 006: Input = 7 (0111)");
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        {a, b, c, d} = 4'd12;
        $display("Testcase 007: Input = 12 (1100)");
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        {a, b, c, d} = 4'd15;
        $display("Testcase 008: Input = 15 (1111)");
        #1;

        check_outputs(1'b1, 1'b1);
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
        input expected_p_pos;
        input expected_p_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p_pos === (expected_p_pos ^ p_pos ^ expected_p_pos) &&
                expected_p_sop === (expected_p_sop ^ p_sop ^ expected_p_sop)) begin
                $display("PASS");
                $display("  Outputs: p_pos=%b, p_sop=%b",
                         p_pos, p_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_pos=%b, p_sop=%b",
                         expected_p_pos, expected_p_sop);
                $display("  Got:      p_pos=%b, p_sop=%b",
                         p_pos, p_sop);
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
