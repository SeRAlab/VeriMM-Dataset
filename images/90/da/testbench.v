`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [1:0] op;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'sd2; b = 4'sd3; op = 2'b00;
            #1;

            check_outputs(4'sd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = -4'sd1; b = -4'sd2; op = 2'b00;
            #1;

            check_outputs(-4'sd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'sd5; b = 4'sd2; op = 2'b01;
            #1;

            check_outputs(4'sd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'sd2; b = 4'sd6; op = 2'b01;
            #1;

            check_outputs(-4'sd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'sd2; b = 4'sd3; op = 2'b10;
            #1;

            check_outputs(4'sd6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = -4'sd2; b = 4'sd3; op = 2'b10;
            #1;

            check_outputs(-4'sd6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'sd6; b = 4'sd2; op = 2'b11;
            #1;

            check_outputs(4'sd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = -4'sd8; b = 4'sd4; op = 2'b11;
            #1;

            check_outputs(-4'sd2);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 4'sd7; b = 4'sd1; op = 2'b00;
            #1;

            check_outputs(-4'sd8);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = -4'sd8; b = -4'sd1; op = 2'b11;
            #1;

            check_outputs(-4'sd8);
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
        input [3:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
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
