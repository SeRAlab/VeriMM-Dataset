`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] dezena;
    reg [3:0] unidade;
    wire [6:0] D;
    wire [6:0] U;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dezena(dezena),
        .unidade(unidade),
        .D(D),
        .U(U)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal 00 (unidade=0, dezena=0)", test_num);
        unidade = 4'd0; dezena = 4'd0;
        #1;

        check_outputs(7'h3F, 7'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal 12 (unidade=2, dezena=1)", test_num);
        unidade = 4'd2; dezena = 4'd1;
        #1;

        check_outputs(7'h06, 7'h5B);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal 34 (unidade=4, dezena=3)", test_num);
        unidade = 4'd4; dezena = 4'd3;
        #1;

        check_outputs(7'h4F, 7'h66);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal 56 (unidade=6, dezena=5)", test_num);
        unidade = 4'd6; dezena = 4'd5;
        #1;

        check_outputs(7'h6D, 7'h7D);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal 78 (unidade=8, dezena=7)", test_num);
        unidade = 4'd8; dezena = 4'd7;
        #1;

        check_outputs(7'h07, 7'h7F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal 99 (unidade=9, dezena=9)", test_num);
        unidade = 4'd9; dezena = 4'd9;
        #1;

        check_outputs(7'h6F, 7'h6F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Invalid Input (unidade=10, dezena=15)", test_num);
        unidade = 4'd10; dezena = 4'd15;
        #1;

        check_outputs(7'h00, 7'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed Valid/Invalid (unidade=5, dezena=12)", test_num);
        unidade = 4'd5; dezena = 4'd12;
        #1;

        check_outputs(7'h00, 7'h6D);
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
        input [6:0] expected_D;
        input [6:0] expected_U;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_U === (expected_U ^ U ^ expected_U)) begin
                $display("PASS");
                $display("  Outputs: D=%h, U=%h",
                         D, U);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, U=%h",
                         expected_D, expected_U);
                $display("  Got:      D=%h, U=%h",
                         D, U);
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
