`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] center_x;
    reg [10:0] center_y;
    reg enable;
    reg [10:0] height;
    reg [10:0] width;
    reg [10:0] x;
    reg [10:0] y;
    wire show;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .center_x(center_x),
        .center_y(center_y),
        .enable(enable),
        .height(height),
        .width(width),
        .x(x),
        .y(y),
        .show(show)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Rect rendering disabled (enable=1)", test_num);
            enable = 1;
            center_x = 200;
            center_y = 200;
            width = 50;
            height = 50;
            x = 200;
            y = 200;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Inside rectangle at center (enable=0)", test_num);
            enable = 0;
            center_x = 300;
            center_y = 300;
            width = 100;
            height = 100;
            x = 300;
            y = 300;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Far outside rectangle", test_num);
            enable = 0;
            center_x = 100;
            center_y = 100;
            width = 20;
            height = 20;
            x = 500;
            y = 500;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: On the boundary (Right Edge)", test_num);

            enable = 0;
            center_x = 400;
            center_y = 400;
            width = 40;
            height = 40;
            x = 420;
            y = 400;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Just outside the boundary (Right Edge + 1)", test_num);
            enable = 0;
            center_x = 400;
            center_y = 400;
            width = 40;
            height = 40;
            x = 421;
            y = 400;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: On the boundary (Top Edge)", test_num);
            enable = 0;
            center_x = 400;
            center_y = 400;
            width = 40;
            height = 40;
            x = 400;
            y = 380;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Just outside the boundary (Top Edge - 1)", test_num);
            enable = 0;
            center_x = 400;
            center_y = 400;
            width = 40;
            height = 40;
            x = 400;
            y = 379;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Corner Check (Bottom-Left)", test_num);
            enable = 0;
            center_x = 150;
            center_y = 150;
            width = 100;
            height = 60;

            x = 100;
            y = 180;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Corner Check (Top-Right)", test_num);
            enable = 0;
            center_x = 150;
            center_y = 150;
            width = 100;
            height = 60;

            x = 200;
            y = 120;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Rectangle with zero dimension", test_num);
            enable = 0;
            center_x = 100;
            center_y = 100;
            width = 0;
            height = 0;
            x = 100;
            y = 100;


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
        input expected_show;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_show === (expected_show ^ show ^ expected_show)) begin
                $display("PASS");
                $display("  Outputs: show=%b",
                         show);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: show=%b",
                         expected_show);
                $display("  Got:      show=%b",
                         show);
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
