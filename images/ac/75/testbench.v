`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] x;
    reg [9:0] x1;
    reg [9:0] x2;
    reg [8:0] y;
    reg [8:0] y1;
    reg [8:0] y2;
    wire d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .x1(x1),
        .x2(x2),
        .y(y),
        .y1(y1),
        .y2(y2),
        .d(d)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Point in center", test_num);
            x1 = 10'd100; x2 = 10'd200;
            y1 = 9'd50;   y2 = 9'd150;
            x = 10'd150;  y = 9'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Point on top-left boundary", test_num);
            x1 = 10'd100; x2 = 10'd200;
            y1 = 9'd50;   y2 = 9'd150;
            x = 10'd100;  y = 9'd50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Point on bottom-right boundary", test_num);
            x1 = 10'd100; x2 = 10'd200;
            y1 = 9'd50;   y2 = 9'd150;
            x = 10'd200;  y = 9'd150;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Point just outside left boundary", test_num);
            x1 = 10'd100; x2 = 10'd200;
            y1 = 9'd50;   y2 = 9'd150;
            x = 10'd99;   y = 9'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Point just outside right boundary", test_num);
            x1 = 10'd100; x2 = 10'd200;
            y1 = 9'd50;   y2 = 9'd150;
            x = 10'd201;  y = 9'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Point just outside top boundary", test_num);
            x1 = 10'd100; x2 = 10'd200;
            y1 = 9'd50;   y2 = 9'd150;
            x = 10'd150;  y = 9'd49;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Point just outside bottom boundary", test_num);
            x1 = 10'd100; x2 = 10'd200;
            y1 = 9'd50;   y2 = 9'd150;
            x = 10'd150;  y = 9'd151;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum range check", test_num);
            x1 = 10'd0;    x2 = 10'd1023;
            y1 = 9'd0;     y2 = 9'd511;
            x = 10'd1023;  y = 9'd511;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single point rectangle check", test_num);
            x1 = 10'd300; x2 = 10'd300;
            y1 = 9'd200;  y2 = 9'd200;
            x = 10'd300;  y = 9'd200;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Far outside bounds", test_num);
            x1 = 10'd10;  x2 = 10'd20;
            y1 = 9'd10;   y2 = 9'd20;
            x = 10'd500;  y = 9'd400;
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
        input expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: d=%b",
                         d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%b",
                         expected_d);
                $display("  Got:      d=%b",
                         d);
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
