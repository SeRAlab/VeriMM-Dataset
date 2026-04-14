`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in00;
    reg [31:0] in01;
    wire out00;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in00(in00),
        .in01(in01),
        .out00(out00)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        in00 = 32'sd100;
        in01 = 32'sd50;
        $display("Testcase %0d: Positive vs Positive (Greater)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        in00 = 32'sd50;
        in01 = 32'sd100;
        $display("Testcase %0d: Positive vs Positive (Lesser)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        in00 = 32'sd75;
        in01 = 32'sd75;
        $display("Testcase %0d: Positive vs Positive (Equal)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        in00 = -32'sd10;
        in01 = -32'sd20;
        $display("Testcase %0d: Negative vs Negative (Greater)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        in00 = -32'sd50;
        in01 = -32'sd20;
        $display("Testcase %0d: Negative vs Negative (Lesser)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        in00 = -32'sd100;
        in01 = -32'sd100;
        $display("Testcase %0d: Negative vs Negative (Equal)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        in00 = 32'sd1;
        in01 = -32'sd1;
        $display("Testcase %0d: Positive vs Negative (Greater)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        in00 = -32'sd5;
        in01 = 32'sd5;
        $display("Testcase %0d: Negative vs Positive (Lesser)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        in00 = 32'sd0;
        in01 = 32'sd0;
        $display("Testcase %0d: Zero vs Zero (Equal)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        in00 = 32'sd0;
        in01 = -32'sd1;
        $display("Testcase %0d: Zero vs Negative (Greater)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        in00 = 32'sd0;
        in01 = 32'sd1;
        $display("Testcase %0d: Zero vs Positive (Lesser)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        in00 = 32'h7FFFFFFF;
        in01 = 32'h80000000;
        $display("Testcase %0d: Max Positive vs Max Negative (Greater)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        in00 = 32'h80000000;
        in01 = 32'h7FFFFFFF;
        $display("Testcase %0d: Max Negative vs Max Positive (Lesser)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        in00 = 32'h7FFFFFFF;
        in01 = 32'h7FFFFFFF;
        $display("Testcase %0d: Boundary Equal Positive", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        in00 = 32'h80000000;
        in01 = 32'h80000000;
        $display("Testcase %0d: Boundary Equal Negative", test_num);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_out00;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out00 === (expected_out00 ^ out00 ^ expected_out00)) begin
                $display("PASS");
                $display("  Outputs: out00=%b",
                         out00);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out00=%b",
                         expected_out00);
                $display("  Got:      out00=%b",
                         out00);
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
