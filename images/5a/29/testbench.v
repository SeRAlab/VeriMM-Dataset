`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [511:0] in;
    wire [127:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: All-Zero Block", test_num);
            in = 512'h0;

            #1;


            check_outputs(128'h704b232d15074b965b0759ac62b92c20);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: All-Ones Block", test_num);
            in = {16{32'hFFFFFFFF}};
            #1;

            check_outputs(128'h235b3992222f7469a5023927d6320023);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Message 'abc' Padded Block", test_num);
            in = 512'h0;
            in[31:0]   = 32'h80636261;
            in[479:448] = 32'h00000018;

            #1;


            check_outputs(128'h727f617dd6963f7d3cd24fb090015098);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Message 'a' Padded Block", test_num);
            in = 512'h0;
            in[31:0]   = 32'h00008061;
            in[479:448] = 32'h00000008;

            #1;


            check_outputs(128'h6977266131c399e2c0f1b6a80cc175b9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Empty Message Padded Block", test_num);
            in = 512'h0;
            in[31:0]   = 32'h00000080;
            in[479:448] = 32'h00000000;

            #1;


            check_outputs(128'hecf8427ee98009988f00b204d41d8cd9);
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
        input [127:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
