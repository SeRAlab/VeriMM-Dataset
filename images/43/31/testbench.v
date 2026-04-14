`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] din;
    wire [9:0] analog_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .analog_out(analog_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum input (0x00)", test_num);
            din = 8'h00;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small step input (0x01)", test_num);
            din = 8'h01;
            #1;

            check_outputs(10'h004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-scale input (0x80)", test_num);
            din = 8'h80;
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High-scale input (0xFE)", test_num);
            din = 8'hFE;
            #1;

            check_outputs(10'h3F8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum input (0xFF)", test_num);
            din = 8'hFF;
            #1;

            check_outputs(10'h3FC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing potential undefined input (0xA5)", test_num);
            din = 8'hA5;


            #1;



            check_outputs(10'h294);
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
        input [9:0] expected_analog_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_out === (expected_analog_out ^ analog_out ^ expected_analog_out)) begin
                $display("PASS");
                $display("  Outputs: analog_out=%h",
                         analog_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_out=%h",
                         expected_analog_out);
                $display("  Got:      analog_out=%h",
                         analog_out);
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
