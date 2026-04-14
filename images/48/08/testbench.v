`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CE;
    reg CLK;
    reg [31:0] process_input;
    wire [15:0] process_output;

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
            test_num = test_num + 1;
            $display("Testcase %0d: Lower 16 bits = 1 (Expected Output = 0)", test_num);
            CE = 1;
            process_input = 32'hABCD_0001;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (0x0010 + 0x0020)", test_num);
            CE = 1;
            process_input = 32'h0010_0020;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(16'h0030);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with L=0 (0x1234 + 0x0000)", test_num);
            CE = 1;
            process_input = 32'h1234_0000;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Overflow (0xFFFF + 0x0002)", test_num);
            CE = 1;
            process_input = 32'hFFFF_0002;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CE De-asserted (Output should not change)", test_num);

            CE = 1;
            process_input = 32'h0001_0002;
            @(posedge CLK);
            #2;


            CE = 0;
            process_input = 32'hAAAA_BBBB;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(16'h0003);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower 16 bits = 1 with large U (Expected Output = 0)", test_num);
            CE = 1;
            process_input = 32'hFFFF_0001;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_process_output;
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
