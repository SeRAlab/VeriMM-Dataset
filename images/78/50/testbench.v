`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [15:0] max;
    reg [15:0] min;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .max(max),
        .min(min),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input within range (Positive)", test_num);
            in  = 16'sd500;
            min = -16'sd1000;
            max = 16'sd1000;

            #1;


            check_outputs(16'sd500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input within range (Negative)", test_num);
            in  = -16'sd250;
            min = -16'sd1000;
            max = 16'sd1000;

            #1;


            check_outputs(-16'sd250);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input exceeds Max (Saturation High)", test_num);
            in  = 16'sd1500;
            min = -16'sd1000;
            max = 16'sd1000;

            #1;


            check_outputs(16'sd1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input below Min (Saturation Low)", test_num);
            in  = -16'sd1500;
            min = -16'sd1000;
            max = 16'sd1000;

            #1;


            check_outputs(-16'sd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input exactly at Max boundary", test_num);
            in  = 16'sd1000;
            min = -16'sd1000;
            max = 16'sd1000;

            #1;


            check_outputs(16'sd1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input exactly at Min boundary", test_num);
            in  = -16'sd1000;
            min = -16'sd1000;
            max = 16'sd1000;

            #1;


            check_outputs(-16'sd1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum signed value saturation", test_num);
            in  = 16'sh7FFF;
            min = 16'sd0;
            max = 16'sd100;

            #1;


            check_outputs(16'sd100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum signed value saturation", test_num);
            in  = 16'sh8000;
            min = -16'sd50;
            max = 16'sd50;

            #1;


            check_outputs(-16'sd50);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero input and boundaries", test_num);
            in  = 16'sd0;
            min = -16'sd10;
            max = 16'sd10;

            #1;


            check_outputs(16'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Range in negative region", test_num);
            in  = -16'sd5;
            min = -16'sd50;
            max = -16'sd20;

            #1;


            check_outputs(-16'sd20);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_out;
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
