`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire error;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .error(error),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'sd100; b = 32'sd0;
            #1;

            check_outputs(1'b1, 32'hxxxxxxxx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'sd7; b = 32'sd3;

            #1;


            check_outputs(1'b0, 32'sd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = -32'sd7; b = 32'sd3;

            #1;


            check_outputs(1'b0, 32'sd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'sd7; b = -32'sd3;

            #1;


            check_outputs(1'b0, 32'sd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = -32'sd7; b = -32'sd3;

            #1;


            check_outputs(1'b0, 32'sd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'sd0; b = 32'sd15;
            #1;

            check_outputs(1'b0, 32'sd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'sd12; b = 32'sd4;
            #1;

            check_outputs(1'b0, 32'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = -32'sd12; b = 32'sd4;
            #1;

            check_outputs(1'b0, 32'sd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'sd1000000; b = 32'sd7;

            #1;


            check_outputs(1'b0, 32'sd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = -32'sd2147483648; b = 32'sd10;

            #1;


            check_outputs(1'b0, 32'sd2);
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
        input expected_error;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: error=%b, result=%h",
                         error, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, result=%h",
                         expected_error, expected_result);
                $display("  Got:      error=%b, result=%h",
                         error, result);
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
