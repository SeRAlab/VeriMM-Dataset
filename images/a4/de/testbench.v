`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg option;
    wire [7:0] selection;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .option(option),
        .selection(selection)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select b when option is low (Basic)", test_num);
        a = 8'hAA;
        b = 8'h55;
        option = 1'b0;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select a when option is high (Basic)", test_num);
        a = 8'hAA;
        b = 8'h55;
        option = 1'b1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select b with all zeros/ones", test_num);
        a = 8'h00;
        b = 8'hFF;
        option = 1'b0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select a with all zeros/ones", test_num);
        a = 8'h00;
        b = 8'hFF;
        option = 1'b1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern selection (b)", test_num);
        a = 8'h12;
        b = 8'h34;
        option = 1'b0;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random pattern selection (a)", test_num);
        a = 8'hDE;
        b = 8'hAD;
        option = 1'b1;
        #1;

        check_outputs(8'hDE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Edge case all zeros", test_num);
        a = 8'h00;
        b = 8'h00;
        option = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Edge case all ones", test_num);
        a = 8'hFF;
        b = 8'hFF;
        option = 1'b1;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_selection;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_selection === (expected_selection ^ selection ^ expected_selection)) begin
                $display("PASS");
                $display("  Outputs: selection=%h",
                         selection);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: selection=%h",
                         expected_selection);
                $display("  Got:      selection=%h",
                         selection);
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
