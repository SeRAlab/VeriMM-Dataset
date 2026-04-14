`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] lin;
    wire [2:0] exp;
    wire [9:0] man;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .lin(lin),
        .exp(exp),
        .man(man)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative input (MSB set)", test_num);
        lin = 16'h8000;
        #1;

        check_outputs(3'd7, 10'h200);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative input (all ones)", test_num);
        lin = 16'hFFFF;
        #1;

        check_outputs(3'd7, 10'h3FF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive input, Leading bit 14 (Exp 7)", test_num);
        lin = 16'h4001;
        #1;

        check_outputs(3'd7, 10'h200);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive input, Leading bit 13 (Exp 6)", test_num);
        lin = 16'h2000;
        #1;

        check_outputs(3'd6, 10'h200);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive input, Leading bit 12 (Exp 5)", test_num);
        lin = 16'h1A00;
        #1;

        check_outputs(3'd5, 10'h340);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive input, Leading bit 11 (Exp 4)", test_num);
        lin = 16'h0804;
        #1;

        check_outputs(3'd4, 10'h201);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive input, Leading bit 10 (Exp 3)", test_num);
        lin = 16'h0402;
        #1;

        check_outputs(3'd3, 10'h201);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive input, Leading bit 9 (Exp 2)", test_num);
        lin = 16'h02AA;
        #1;

        check_outputs(3'd2, 10'h2AA);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive input, Leading bit 8 (Exp 1)", test_num);
        lin = 16'h0155;
        #1;

        check_outputs(3'd1, 10'h155);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive input, Small value (Exp 0)", test_num);
        lin = 16'h007F;
        #1;

        check_outputs(3'd0, 10'h07F);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero input", test_num);
        lin = 16'h0000;
        #1;

        check_outputs(3'd0, 10'h000);
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
        testcase011();
        
        
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
        input [2:0] expected_exp;
        input [9:0] expected_man;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exp === (expected_exp ^ exp ^ expected_exp) &&
                expected_man === (expected_man ^ man ^ expected_man)) begin
                $display("PASS");
                $display("  Outputs: exp=%h, man=%h",
                         exp, man);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exp=%h, man=%h",
                         expected_exp, expected_man);
                $display("  Got:      exp=%h, man=%h",
                         exp, man);
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
