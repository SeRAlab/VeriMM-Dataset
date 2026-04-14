`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk_en;
    reg clk_in;
    reg clk_out;
    reg gate_din_0;
    reg gate_din_1;
    reg gold_din_0;
    reg gold_din_1;
    reg latch_in;
    reg oen;
    reg pin_reg;
    wire dout_0;
    wire dout_1;
    wire gate_global;
    wire gate_pin;
    wire gold_global;
    wire gold_pin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_en(clk_en),
        .clk_in(clk_in),
        .clk_out(clk_out),
        .gate_din_0(gate_din_0),
        .gate_din_1(gate_din_1),
        .gold_din_0(gold_din_0),
        .gold_din_1(gold_din_1),
        .latch_in(latch_in),
        .oen(oen),
        .pin_reg(pin_reg),
        .dout_0(dout_0),
        .dout_1(dout_1),
        .gate_global(gate_global),
        .gate_pin(gate_pin),
        .gold_global(gold_global),
        .gold_pin(gold_pin)
    );
    task testcase001;

        begin
            test_num = 1;

            clk_en = 0; clk_in = 0; clk_out = 0; oen = 0;
            pin_reg = 0; latch_in = 0;
            gold_din_0 = 0; gold_din_1 = 0; gate_din_0 = 0; gate_din_1 = 0;

            $display("\nTestcase %0d: All inputs zero", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            clk_en = 0; pin_reg = 1; latch_in = 1;
            $display("\nTestcase %0d: clk_en disabled - pins and global should be 0", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            clk_en = 1; pin_reg = 1; latch_in = 0;
            $display("\nTestcase %0d: clk_en enabled - pin_reg mapping", test_num);

            #1;


            check_outputs(0, 0, 0, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            clk_en = 1; pin_reg = 0; latch_in = 1;
            $display("\nTestcase %0d: clk_en enabled - latch_in mapping to global", test_num);

            #1;


            check_outputs(0, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            clk_en = 0; pin_reg = 0; latch_in = 0;
            oen = 0; clk_out = 1;
            gold_din_0 = 1; gold_din_1 = 0; gate_din_0 = 0; gate_din_1 = 0;
            $display("\nTestcase %0d: dout_0 active via gold_din_0", test_num);
            #1;

            check_outputs(1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            oen = 0; clk_out = 1;
            gold_din_0 = 0; gold_din_1 = 0; gate_din_0 = 1; gate_din_1 = 0;
            $display("\nTestcase %0d: dout_0 active via gate_din_0", test_num);
            #1;

            check_outputs(1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            oen = 0; clk_out = 1;
            gold_din_0 = 0; gold_din_1 = 1; gate_din_0 = 0; gate_din_1 = 0;
            $display("\nTestcase %0d: dout_1 active via gold_din_1", test_num);
            #1;

            check_outputs(0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;

            oen = 0; clk_out = 1;
            gold_din_0 = 0; gold_din_1 = 0; gate_din_0 = 0; gate_din_1 = 1;
            $display("\nTestcase %0d: dout_1 active via gate_din_1", test_num);
            #1;

            check_outputs(0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;

            oen = 1; clk_out = 1;
            gold_din_0 = 1; gold_din_1 = 1; gate_din_0 = 1; gate_din_1 = 1;
            $display("\nTestcase %0d: oen disabled - douts should be 0", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;

            oen = 0; clk_out = 0;
            gold_din_0 = 1; gold_din_1 = 1; gate_din_0 = 1; gate_din_1 = 1;
            $display("\nTestcase %0d: clk_out inactive - douts should be 0", test_num);
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;

            clk_en = 1; pin_reg = 1; latch_in = 1;
            oen = 0; clk_out = 1;
            gold_din_0 = 1; gold_din_1 = 1; gate_din_0 = 1; gate_din_1 = 1;
            $display("\nTestcase %0d: Comprehensive check - all subsystems enabled", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 1, 1);
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
        input expected_dout_0;
        input expected_dout_1;
        input expected_gate_global;
        input expected_gate_pin;
        input expected_gold_global;
        input expected_gold_pin;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout_0 === (expected_dout_0 ^ dout_0 ^ expected_dout_0) &&
                expected_dout_1 === (expected_dout_1 ^ dout_1 ^ expected_dout_1) &&
                expected_gate_global === (expected_gate_global ^ gate_global ^ expected_gate_global) &&
                expected_gate_pin === (expected_gate_pin ^ gate_pin ^ expected_gate_pin) &&
                expected_gold_global === (expected_gold_global ^ gold_global ^ expected_gold_global) &&
                expected_gold_pin === (expected_gold_pin ^ gold_pin ^ expected_gold_pin)) begin
                $display("PASS");
                $display("  Outputs: dout_0=%b, dout_1=%b, gate_global=%b, gate_pin=%b, gold_global=%b, gold_pin=%b",
                         dout_0, dout_1, gate_global, gate_pin, gold_global, gold_pin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout_0=%b, dout_1=%b, gate_global=%b, gate_pin=%b, gold_global=%b, gold_pin=%b",
                         expected_dout_0, expected_dout_1, expected_gate_global, expected_gate_pin, expected_gold_global, expected_gold_pin);
                $display("  Got:      dout_0=%b, dout_1=%b, gate_global=%b, gate_pin=%b, gold_global=%b, gold_pin=%b",
                         dout_0, dout_1, gate_global, gate_pin, gold_global, gold_pin);
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
