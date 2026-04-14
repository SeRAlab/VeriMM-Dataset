`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [32:0] process_input;
    wire [31:0] process_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .process_input(process_input),
        .process_output(process_output)
    );
    task testcase001;

    begin
        test_num = 1;
        process_input = {1'b0, 32'h00000000};
        CLK = 0; #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        process_input = {1'b1, 32'h00000000};
        CLK = 0; #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        process_input = {1'b0, 32'hFFFFFFFF};
        CLK = 0; #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        process_input = {1'b1, 32'hFFFFFFFF};
        CLK = 0; #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        process_input = {1'b1, 32'h12345678};
        CLK = 0; #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'h12345679);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        process_input = {1'b0, 32'hABCDE000};
        CLK = 0; #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'hABCDE000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        process_input = {1'b1, 32'h7FFFFFFF};
        CLK = 0; #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        process_input = {1'b1, 32'h0000FFFF};
        CLK = 0; #5; CLK = 1; #5; CLK = 0;
        #1;

        check_outputs(32'h00010000);
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
        input [31:0] expected_process_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_process_output === (expected_process_output ^ process_output ^ expected_process_output)) begin
                $display("PASS");
                $display("  Outputs: process_output=%h",
                         process_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: process_output=%h",
                         expected_process_output);
                $display("  Got:      process_output=%h",
                         process_output);
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
