`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [31:0] io_input;
    reg reset;
    wire [7:0] io_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_input(io_input),
        .reset(reset),
        .io_output(io_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Extraction of 0xFF", test_num);
            reset = 1;
            io_input = 32'h0;
            #15;
            reset = 0;
            io_input = 32'h00FF0000;
            @(posedge clock);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Extraction of 0x34 from 0x12345678", test_num);
            reset = 1;
            #15;
            reset = 0;
            io_input = 32'h12345678;
            @(posedge clock);
            #2;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Extraction from high word boundaries", test_num);
            reset = 1;
            #15;
            reset = 0;
            io_input = 32'hABCD1234;
            @(posedge clock);
            #2;
            #1;

            check_outputs(8'hCD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones input", test_num);
            reset = 1;
            #15;
            reset = 0;
            io_input = 32'hFFFFFFFF;
            @(posedge clock);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Lower bits discarding", test_num);
            reset = 1;
            #15;
            reset = 0;
            io_input = 32'h0000FFFF;
            @(posedge clock);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset assertion", test_num);
            reset = 0;
            io_input = 32'hFFFFFFFF;
            @(posedge clock);
            reset = 1;
            @(posedge clock);
            #2;

            #1;


            check_outputs(8'h00);
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
        input [7:0] expected_io_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_output === (expected_io_output ^ io_output ^ expected_io_output)) begin
                $display("PASS");
                $display("  Outputs: io_output=%h",
                         io_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_output=%h",
                         expected_io_output);
                $display("  Got:      io_output=%h",
                         io_output);
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
