`timescale 1ns/1ps

module binary_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire gt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_comparator dut (
        .a(a),
        .b(b),
        .gt(gt)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0, b=0 (Equal)", test_num);
            a = 4'd0;
            b = 4'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=5, b=2 (a > b)", test_num);
            a = 4'd5;
            b = 4'd2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=3, b=7 (a < b)", test_num);
            a = 4'd3;
            b = 4'd7;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=15, b=15 (Equal Max)", test_num);
            a = 4'd15;
            b = 4'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=15, b=0 (Max a, Min b)", test_num);
            a = 4'd15;
            b = 4'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=0, b=15 (Min a, Max b)", test_num);
            a = 4'd0;
            b = 4'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=8, b=7 (MSB difference)", test_num);
            a = 4'b1000;
            b = 4'b0111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=10, b=11 (LSB difference)", test_num);
            a = 4'b1010;
            b = 4'b1011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=13, b=12 (LSB difference)", test_num);
            a = 4'b1101;
            b = 4'b1100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a=4, b=4 (Mid-range Equal)", test_num);
            a = 4'd4;
            b = 4'd4;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_comparator Testbench");
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
        input expected_gt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gt === (expected_gt ^ gt ^ expected_gt)) begin
                $display("PASS");
                $display("  Outputs: gt=%b",
                         gt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gt=%b",
                         expected_gt);
                $display("  Got:      gt=%b",
                         gt);
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
