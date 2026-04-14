`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [23:0] inp;
    reg process_CE;
    wire [31:0] process_output;

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

            inp = 24'h0;
            process_CE = 0;
            @(posedge CLK);


            inp = 24'h000005;
            process_CE = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'h00000005);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            inp = 24'h0;
            process_CE = 0;
            @(posedge CLK);

            inp = 24'h800001;
            process_CE = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(32'hFF800001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;

            inp = 24'hAAAAAA;
            process_CE = 1;
            @(posedge CLK);
            #1;


            inp = 24'hBBBBBB;
            process_CE = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(32'hFFAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            inp = 24'h0;
            process_CE = 0;
            @(posedge CLK);

            inp = 24'h7FFFFF;
            process_CE = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'h007FFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            inp = 24'h0;
            process_CE = 0;
            @(posedge CLK);

            inp = 24'hFFFFFF;
            process_CE = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            inp = 24'hFFFFFF;
            process_CE = 1;
            @(posedge CLK);

            inp = 24'h000000;
            process_CE = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'h00000000);
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
