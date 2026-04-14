`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [15:0] inp;
    reg process_CE;
    wire [7:0] process_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .inp(inp),
        .process_CE(process_CE),
        .process_output(process_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Lower byte extraction (0x1234)", test_num);

        inp = 16'h0000;
        process_CE = 1'b0;
        @(posedge CLK);

        inp = 16'h1234;
        process_CE = 1'b1;
        @(posedge CLK);
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Upper byte full, lower byte zero (0xFF00)", test_num);
        inp = 16'hFF00;
        process_CE = 1'b1;
        @(posedge CLK);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All ones (0xFFFF)", test_num);
        inp = 16'hFFFF;
        process_CE = 1'b1;
        @(posedge CLK);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Alternating bits (0x55AA)", test_num);
        inp = 16'h55AA;
        process_CE = 1'b1;
        @(posedge CLK);
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Clock Enable Test (CE=0)", test_num);

        inp = 16'h1122;
        process_CE = 1'b0;
        @(posedge CLK);

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Resume after CE enabled", test_num);
        inp = 16'h1122;
        process_CE = 1'b1;
        @(posedge CLK);
        #1;

        check_outputs(8'h22);
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
