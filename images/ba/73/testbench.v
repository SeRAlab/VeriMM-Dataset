`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    wire sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 8'd0;
            b = 8'd123;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 8'd45;
            b = 8'd1;
            #1;

            check_outputs(8'd45);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 8'd12;
            b = 8'd5;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 8'd5;
            b = 8'd12;
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 8'd7;
            b = 8'd16;
            #1;

            check_outputs(8'd112);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 8'd20;
            b = 8'd20;
            #1;

            check_outputs(8'd144);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 8'hFF;
            b = 8'hFF;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 8'd255;
            b = 8'd2;
            #1;

            check_outputs(8'd254);
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
        input expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%b",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%b",
                         expected_sum);
                $display("  Got:      sum=%b",
                         sum);
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
