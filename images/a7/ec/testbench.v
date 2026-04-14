`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg auxValue;
    reg [3:0] value;
    wire [6:0] segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .auxValue(auxValue),
        .value(value),
        .segments(segments)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Testing digit 0 with auxValue=1", test_num);
            auxValue = 1'b1;
            value = 4'h0;
            #1;

            check_outputs(7'b0111111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Testing digit 1 with auxValue=1", test_num);
            auxValue = 1'b1;
            value = 4'h1;
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Testing digit 4 with auxValue=1", test_num);
            auxValue = 1'b1;
            value = 4'h4;
            #1;

            check_outputs(7'b1100110);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Testing digit 8 with auxValue=1", test_num);
            auxValue = 1'b1;
            value = 4'h8;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Testing Hex A with auxValue=1", test_num);
            auxValue = 1'b1;
            value = 4'hA;
            #1;

            check_outputs(7'b1110111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Testing Hex F with auxValue=1", test_num);
            auxValue = 1'b1;
            value = 4'hF;
            #1;

            check_outputs(7'b1110001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Testing condition auxValue=0 (Blanking)", test_num);
            auxValue = 1'b0;
            value = 4'h8;
            #1;

            check_outputs(7'b0000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Testing condition auxValue=0 with value 0", test_num);
            auxValue = 1'b0;
            value = 4'h0;
            #1;

            check_outputs(7'b0000000);
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
        input [6:0] expected_segments;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segments === (expected_segments ^ segments ^ expected_segments)) begin
                $display("PASS");
                $display("  Outputs: segments=%h",
                         segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segments=%h",
                         expected_segments);
                $display("  Got:      segments=%h",
                         segments);
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
