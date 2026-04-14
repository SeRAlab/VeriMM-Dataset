`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] ctrl;
    reg [3:0] sel;
    wire resistance;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .sel(sel),
        .resistance(resistance)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs zero (Minimum resistance/Off)", test_num);
        ctrl = 3'b000;
        sel = 4'b0000;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select bit 0 of control", test_num);
        ctrl = 3'b001;
        sel = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select bit 1 of control", test_num);
        ctrl = 3'b010;
        sel = 4'b0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select bit 2 of control", test_num);
        ctrl = 3'b100;
        sel = 4'b0010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select bit with 0 value", test_num);
        ctrl = 3'b101;
        sel = 4'b0001;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max control value, select position 0", test_num);
        ctrl = 3'b111;
        sel = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Out of range wiper position (Higher than n-1)", test_num);
        ctrl = 3'b111;
        sel = 4'b1111;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Rapid toggle check", test_num);
        ctrl = 3'b101;
        sel = 4'b0000; #5;
        sel = 4'b0001; #5;
        sel = 4'b0010;
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
        input expected_resistance;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resistance === (expected_resistance ^ resistance ^ expected_resistance)) begin
                $display("PASS");
                $display("  Outputs: resistance=%b",
                         resistance);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resistance=%b",
                         expected_resistance);
                $display("  Got:      resistance=%b",
                         resistance);
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
