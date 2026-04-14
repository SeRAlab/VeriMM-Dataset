`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CE;
    reg CLK;
    reg [8:0] process_input;
    wire [7:0] process_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE(CE),
        .CLK(CLK),
        .process_input(process_input),
        .process_output(process_output)
    );
    task testcase001;

    begin
        test_num = 1;

        CE = 0;
        process_input = 9'h000;
        @(posedge CLK);


        CE = 1;
        process_input = {1'b1, 8'd5};
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd6);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        CE = 0;
        process_input = 9'h000;
        @(posedge CLK);


        CE = 1;
        process_input = {1'b0, 8'd5};
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        CE = 0;
        process_input = 9'h000;
        @(posedge CLK);


        CE = 1;
        process_input = {1'b1, 8'd127};
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        CE = 0;
        process_input = 9'h000;
        @(posedge CLK);


        CE = 1;
        process_input = {1'b1, 8'd126};
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd127);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        CE = 0;
        process_input = 9'h000;
        @(posedge CLK);


        CE = 1;
        process_input = {1'b1, 8'd128};
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd129);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        CE = 0;
        process_input = 9'h000;
        @(posedge CLK);


        CE = 1;
        process_input = {1'b1, 8'd255};
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        CE = 1;
        process_input = {1'b0, 8'd42};
        @(posedge CLK);


        CE = 0;
        process_input = {1'b1, 8'd10};
        @(posedge CLK);
        #1;



        #1;




        check_outputs(8'd42);
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
        input [7:0] expected_process_output;
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
