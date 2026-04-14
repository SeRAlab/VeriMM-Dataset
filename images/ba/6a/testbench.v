`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    wire [31:0] all;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .all(all)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a = 4'h0", test_num);
            a = 4'h0;
            #1;

            check_outputs(32'hC3824100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a = 4'hF", test_num);
            a = 4'hF;
            #1;

            check_outputs(32'hFFBE7D3C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a = 4'hA", test_num);
            a = 4'hA;
            #1;

            check_outputs(32'hEBAA6928);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a = 4'h5", test_num);
            a = 4'h5;
            #1;

            check_outputs(32'hD7965514);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a = 4'h3", test_num);
            a = 4'h3;
            #1;

            check_outputs(32'hCF8E4D0C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a = 4'hC", test_num);
            a = 4'hC;
            #1;

            check_outputs(32'hF3B27130);
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
        input [31:0] expected_all;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_all === (expected_all ^ all ^ expected_all)) begin
                $display("PASS");
                $display("  Outputs: all=%h",
                         all);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: all=%h",
                         expected_all);
                $display("  Got:      all=%h",
                         all);
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
