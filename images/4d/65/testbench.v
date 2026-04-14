`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in1;
    reg [3:0] in2;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            in1 = 4'sb0000;
            in2 = 4'sb0000;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            in1 = 4'sd2;
            in2 = 4'sd3;
            #1;

            check_outputs(8'sd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            in1 = 4'sd7;
            in2 = 4'sd7;
            #1;

            check_outputs(8'sd49);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            in1 = -4'sd8;
            in2 = -4'sd8;
            #1;

            check_outputs(8'sd64);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            in1 = -4'sd8;
            in2 = 4'sd7;
            #1;

            check_outputs(-8'sd56);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            in1 = 4'sd3;
            in2 = -4'sd4;
            #1;

            check_outputs(-8'sd12);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            in1 = -4'sd1;
            in2 = 4'sd5;
            #1;

            check_outputs(-8'sd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            in1 = -4'sd1;
            in2 = -4'sd1;
            #1;

            check_outputs(8'sd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            in1 = -4'sd5;
            in2 = 4'sd0;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            in1 = 4'sd1;
            in2 = -4'sd8;
            #1;

            check_outputs(-8'sd8);
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
        input [7:0] expected_out;
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
