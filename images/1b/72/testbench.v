`timescale 1ns/1ps

module quick_sort_partition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] num0;
    reg [7:0] num1;
    reg [7:0] num2;
    reg [7:0] num3;
    reg [7:0] pivot;
    wire [7:0] greater0;
    wire [7:0] greater1;
    wire [7:0] less0;
    wire [7:0] less1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quick_sort_partition dut (
        .num0(num0),
        .num1(num1),
        .num2(num2),
        .num3(num3),
        .pivot(pivot),
        .greater0(greater0),
        .greater1(greater1),
        .less0(less0),
        .less1(less1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Balanced Partition (2 less, 2 greater)", test_num);
            num0 = 8'd10;
            num1 = 8'd50;
            num2 = 8'd20;
            num3 = 8'd60;
            pivot = 8'd30;

            #1;


            check_outputs(8'd50, 8'd60, 8'd10, 8'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pivot Equality Check (Greater or Equal)", test_num);
            num0 = 8'd30;
            num1 = 8'd15;
            num2 = 8'd30;
            num3 = 8'd10;
            pivot = 8'd30;

            #1;


            check_outputs(8'd30, 8'd30, 8'd15, 8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only One Less Than Pivot", test_num);
            num0 = 8'd40;
            num1 = 8'd5;
            num2 = 8'd45;
            num3 = 8'd50;
            pivot = 8'd30;

            #1;


            check_outputs(8'd40, 8'd45, 8'd5, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Only One Greater Than Pivot", test_num);
            num0 = 8'd10;
            num1 = 8'd15;
            num2 = 8'd20;
            num3 = 8'd80;
            pivot = 8'd30;

            #1;


            check_outputs(8'd80, 8'd0, 8'd10, 8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Greater Than Pivot", test_num);
            num0 = 8'd100;
            num1 = 8'd110;
            num2 = 8'd120;
            num3 = 8'd130;
            pivot = 8'd50;

            #1;


            check_outputs(8'd100, 8'd110, 8'd0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Less Than Pivot", test_num);
            num0 = 8'd5;
            num1 = 8'd10;
            num2 = 8'd15;
            num3 = 8'd20;
            pivot = 8'd50;

            #1;


            check_outputs(8'd0, 8'd0, 8'd5, 8'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Values (0 and 255)", test_num);
            num0 = 8'd0;
            num1 = 8'd255;
            num2 = 8'd0;
            num3 = 8'd255;
            pivot = 8'd128;
            #1;

            check_outputs(8'd255, 8'd255, 8'd0, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quick_sort_partition Testbench");
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
        input [7:0] expected_greater0;
        input [7:0] expected_greater1;
        input [7:0] expected_less0;
        input [7:0] expected_less1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_greater0 === (expected_greater0 ^ greater0 ^ expected_greater0) &&
                expected_greater1 === (expected_greater1 ^ greater1 ^ expected_greater1) &&
                expected_less0 === (expected_less0 ^ less0 ^ expected_less0) &&
                expected_less1 === (expected_less1 ^ less1 ^ expected_less1)) begin
                $display("PASS");
                $display("  Outputs: greater0=%h, greater1=%h, less0=%h, less1=%h",
                         greater0, greater1, less0, less1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater0=%h, greater1=%h, less0=%h, less1=%h",
                         expected_greater0, expected_greater1, expected_less0, expected_less1);
                $display("  Got:      greater0=%h, greater1=%h, less0=%h, less1=%h",
                         greater0, greater1, less0, less1);
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
