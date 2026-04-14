`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg data;
    wire result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;


            data = 8'b00000000;
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = 8'b11111111;
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = 8'b10101010;
            #1;

            check_outputs(8'b01010101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = 8'b01010101;
            #1;

            check_outputs(8'b10101010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = 8'b11110000;
            #1;

            check_outputs(8'b00001111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = 8'hC3;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data = 8'h96;
            #1;

            check_outputs(8'h69);
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
        input expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%b",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%b",
                         expected_result);
                $display("  Got:      result=%b",
                         result);
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
