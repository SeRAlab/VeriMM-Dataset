`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] a;
    reg [11:0] b;
    reg et;
    reg gt;
    reg lt;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .et(et),
        .gt(gt),
        .lt(lt),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a > b, gt=1, lt=0, et=0", test_num);
            a = 12'd2048;
            b = 12'd1024;
            gt = 1'b1;
            lt = 1'b0;
            et = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a > b, gt=0, lt=1, et=1", test_num);
            a = 12'd2048;
            b = 12'd1024;
            gt = 1'b0;
            lt = 1'b1;
            et = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a < b, gt=0, lt=1, et=0", test_num);
            a = 12'd512;
            b = 12'd1024;
            gt = 1'b0;
            lt = 1'b1;
            et = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a < b, gt=1, lt=0, et=1", test_num);
            a = 12'd512;
            b = 12'd1024;
            gt = 1'b1;
            lt = 1'b0;
            et = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a == b, gt=0, lt=0, et=1", test_num);
            a = 12'd4095;
            b = 12'd4095;
            gt = 1'b0;
            lt = 1'b0;
            et = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a == b, gt=1, lt=1, et=0", test_num);
            a = 12'd4095;
            b = 12'd4095;
            gt = 1'b1;
            lt = 1'b1;
            et = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0, b=0, et=1", test_num);
            a = 12'd0;
            b = 12'd0;
            gt = 1'b0;
            lt = 1'b0;
            et = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No control signals", test_num);
            a = 12'd1234;
            b = 12'd1234;
            gt = 1'b0;
            lt = 1'b0;
            et = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All controls, a > b", test_num);
            a = 12'd4000;
            b = 12'd1;
            gt = 1'b1;
            lt = 1'b1;
            et = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All controls, a < b", test_num);
            a = 12'd1;
            b = 12'd4000;
            gt = 1'b1;
            lt = 1'b1;
            et = 1'b1;
            #1;

            check_outputs(1'b1);
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
