`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 8'sd10;
            b = 8'sd40;
            #1;

            check_outputs(8'sd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 8'sd-10;
            b = 8'sd40;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 8'sd10;
            b = 8'sd-40;
            #1;

            check_outputs(8'sd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 8'sd-10;
            b = 8'sd-40;
            #1;

            check_outputs(8'sd-20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 8'sd120;
            b = 8'sd40;
            #1;

            check_outputs(8'sh82);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 8'sd-120;
            b = 8'sd-40;
            #1;

            check_outputs(8'sh7E);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 8'sd5;
            b = 8'sd3;
            #1;

            check_outputs(8'sd5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 8'sd5;
            b = 8'sd-1;
            #1;

            check_outputs(8'sd4);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 8'sd10;
            b = 8'sd-5;
            #1;

            check_outputs(8'sd8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 8'sd0;
            b = 8'sd-128;
            #1;

            check_outputs(8'sd-32);
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
        input [7:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
