`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg input_clk;
    reg input_en;
    reg input_te;
    wire output_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_clk(input_clk),
        .input_en(input_en),
        .input_te(input_te),
        .output_clk(output_clk)
    );
    task testcase001;

    begin

        input_en = 0;
        input_te = 0;
        test_num = test_num + 1;
        $display("Testcase %03d: Testing Clock Gated (En=0, TE=0)", test_num);

        repeat(2) @(posedge input_clk);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin

        input_en = 0; input_te = 0;
        #10;

        test_num = test_num + 1;
        $display("Testcase %03d: Testing Normal Enable (En=1, TE=0)", test_num);
        input_en = 1;
        input_te = 0;

        repeat(2) @(posedge input_clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin

        input_en = 0; input_te = 0;
        #10;

        test_num = test_num + 1;
        $display("Testcase %03d: Testing Test Enable Override (En=0, TE=1)", test_num);
        input_en = 0;
        input_te = 1;

        repeat(2) @(posedge input_clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin

        input_en = 0; input_te = 0;
        #10;

        test_num = test_num + 1;
        $display("Testcase %03d: Testing Both Enables High (En=1, TE=1)", test_num);
        input_en = 1;
        input_te = 1;

        repeat(2) @(posedge input_clk);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin

        input_en = 0; input_te = 0;
        #10;

        test_num = test_num + 1;
        $display("Testcase %03d: Verifying Low Phase when Enabled", test_num);
        input_en = 1;
        input_te = 0;

        repeat(2) @(negedge input_clk);
        #2;
        #1;

        check_outputs(1'b0);
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
        input expected_output_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_clk === (expected_output_clk ^ output_clk ^ expected_output_clk)) begin
                $display("PASS");
                $display("  Outputs: output_clk=%b",
                         output_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_clk=%b",
                         expected_output_clk);
                $display("  Got:      output_clk=%b",
                         output_clk);
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
