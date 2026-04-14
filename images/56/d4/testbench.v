`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data1;
    reg [15:0] data2;
    wire eq;
    wire gt;
    wire lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data1(data1),
        .data2(data2),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );
    task testcase001;

        begin
            test_num = 1;
            data1 = 16'd0;
            data2 = 16'd0;
            $display("Test %0d: data1=0, data2=0 (Equal Zeros)", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data1 = 16'hFFFF;
            data2 = 16'hFFFF;
            $display("Test %0d: data1=0xFFFF, data2=0xFFFF (Equal Max)", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data1 = 16'd100;
            data2 = 16'd50;
            $display("Test %0d: data1=100, data2=50 (Greater Than)", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data1 = 16'd50;
            data2 = 16'd100;
            $display("Test %0d: data1=50, data2=100 (Less Than)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data1 = 16'hFFFF;
            data2 = 16'h0000;
            $display("Test %0d: data1=0xFFFF, data2=0x0000 (Greater Than Max/Min)", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data1 = 16'h0000;
            data2 = 16'hFFFF;
            $display("Test %0d: data1=0x0000, data2=0xFFFF (Less Than Min/Max)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data1 = 16'h8000;
            data2 = 16'h7FFF;
            $display("Test %0d: data1=0x8000, data2=0x7FFF (Boundary check)", test_num);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data1 = 16'h7FFF;
            data2 = 16'h8000;
            $display("Test %0d: data1=0x7FFF, data2=0x8000 (Boundary check)", test_num);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data1 = 16'hA5A5;
            data2 = 16'hA5A5;
            $display("Test %0d: data1=0xA5A5, data2=0xA5A5 (Pattern Equality)", test_num);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data1 = 16'h1234;
            data2 = 16'h4321;
            $display("Test %0d: data1=0x1234, data2=0x4321 (Random check)", test_num);
            #1;

            check_outputs(0, 0, 1);
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
        input expected_eq;
        input expected_gt;
        input expected_lt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt) &&
                expected_lt === (expected_lt ^ lt ^ expected_lt)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, gt=%b, lt=%b",
                         eq, gt, lt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, gt=%b, lt=%b",
                         expected_eq, expected_gt, expected_lt);
                $display("  Got:      eq=%b, gt=%b, lt=%b",
                         eq, gt, lt);
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
