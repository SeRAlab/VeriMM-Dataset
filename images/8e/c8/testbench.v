`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg process_CE;
    reg [399:0] process_input;
    wire [399:0] process_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .process_CE(process_CE),
        .process_input(process_input),
        .process_output(process_output)
    );
    task reset_signals;

    begin
        process_CE = 0;
        process_input = 400'h0;
        @(posedge CLK);
        #1;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        reset_signals();
        $display("Testcase %0d: All Zeros input", test_num);
        process_input = 400'h0;
        process_CE = 1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(get_expected(400'h0));
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_signals();
        $display("Testcase %0d: All Ones input", test_num);
        process_input = {400{1'b1}};
        process_CE = 1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(get_expected({400{1'b1}}));
    end
        endtask

    task testcase003;

    reg [399:0] val;
    begin
        test_num = test_num + 1;
        reset_signals();
        $display("Testcase %0d: Segment Reordering Check", test_num);

        val = { {336/4{4'hA}}, {64/4{4'hF}} };
        process_input = val;
        process_CE = 1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(get_expected(val));
    end
        endtask

    task testcase004;

    reg [399:0] val;
    integer i;
    begin
        test_num = test_num + 1;
        reset_signals();
        $display("Testcase %0d: Alternating Bit Pattern (55/AA)", test_num);
        for(i=0; i<400; i=i+8) val[i +: 8] = 8'h55;
        process_input = val;
        process_CE = 1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(get_expected(val));
    end
        endtask

    task testcase005;

    reg [399:0] prev_val;
    reg [399:0] new_val;
    begin
        test_num = test_num + 1;
        reset_signals();
        $display("Testcase %0d: Clock Enable (CE) De-assertion check", test_num);


        prev_val = 400'h1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF;
        process_input = prev_val;
        process_CE = 1;
        @(posedge CLK);
        #2;


        new_val = 400'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        process_input = new_val;
        process_CE = 0;
        @(posedge CLK);
        #2;


        #1;



        check_outputs(get_expected(prev_val));
    end
        endtask

    task testcase006;

    reg [399:0] val;
    begin
        test_num = test_num + 1;
        reset_signals();
        $display("Testcase %0d: Walking One in Segment A", test_num);
        val = 400'h0;
        val[0] = 1'b1;
        process_input = val;
        process_CE = 1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(get_expected(val));
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
        input [399:0] expected_process_output;
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
