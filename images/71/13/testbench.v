`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] m;
    reg [5:0] op;
    wire eret;
    wire mfc0;
    wire mtc0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m(m),
        .op(op),
        .eret(eret),
        .mfc0(mfc0),
        .mtc0(mtc0)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing MFC0 (op=16, m=0)", test_num);
        op = 6'b010000;
        m = 5'b00000;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing MTC0 (op=16, m=4)", test_num);
        op = 6'b010000;
        m = 5'b00100;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing ERET (op=16, m=16)", test_num);
        op = 6'b010000;
        m = 5'b10000;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing Zero Inputs", test_num);
        op = 6'b000000;
        m = 5'b00000;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing COP0 op with undefined M", test_num);
        op = 6'b010000;
        m = 5'b11111;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing incorrect OP with valid M pattern", test_num);
        op = 6'b111111;
        m = 5'b00000;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing all inputs high", test_num);
        op = 6'b111111;
        m = 5'b11111;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_eret;
        input expected_mfc0;
        input expected_mtc0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eret === (expected_eret ^ eret ^ expected_eret) &&
                expected_mfc0 === (expected_mfc0 ^ mfc0 ^ expected_mfc0) &&
                expected_mtc0 === (expected_mtc0 ^ mtc0 ^ expected_mtc0)) begin
                $display("PASS");
                $display("  Outputs: eret=%b, mfc0=%b, mtc0=%b",
                         eret, mfc0, mtc0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eret=%b, mfc0=%b, mtc0=%b",
                         expected_eret, expected_mfc0, expected_mtc0);
                $display("  Got:      eret=%b, mfc0=%b, mtc0=%b",
                         eret, mfc0, mtc0);
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
