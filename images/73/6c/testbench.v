`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] x1;
    reg [10:0] x2;
    reg [10:0] x3;
    reg [10:0] y1;
    reg [10:0] y2;
    reg [10:0] y3;
    wire sign;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .sign(sign)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Collinear diagonal points (0,0), (5,5), (10,10)", test_num);
            x1 = 11'd0;  y1 = 11'd0;
            x2 = 11'd5;  y2 = 11'd5;
            x3 = 11'd10; y3 = 11'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: CCW Orientation (0,0), (10,0), (0,10)", test_num);
            x1 = 11'd0;  y1 = 11'd0;
            x2 = 11'd10; y2 = 11'd0;
            x3 = 11'd0;  y3 = 11'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: CW Orientation (0,0), (0,10), (10,0)", test_num);
            x1 = 11'd0;  y1 = 11'd0;
            x2 = 11'd0;  y2 = 11'd10;
            x3 = 11'd10; y3 = 11'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Horizontal Collinear (100,100), (200,100), (300,100)", test_num);
            x1 = 11'd100; y1 = 11'd100;
            x2 = 11'd200; y2 = 11'd100;
            x3 = 11'd300; y3 = 11'd100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vertical Collinear (50,50), (50,150), (50,250)", test_num);
            x1 = 11'd50;  y1 = 11'd50;
            x2 = 11'd50;  y2 = 11'd150;
            x3 = 11'd50;  y3 = 11'd250;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large values CCW (100,100), (900,100), (100,900)", test_num);
            x1 = 11'd100; y1 = 11'd100;
            x2 = 11'd900; y2 = 11'd100;
            x3 = 11'd100; y3 = 11'd900;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large values CW (100,100), (100,900), (900,100)", test_num);
            x1 = 11'd100; y1 = 11'd100;
            x2 = 11'd100; y2 = 11'd900;
            x3 = 11'd900; y3 = 11'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Acute CCW (100,100), (500,200), (200,600)", test_num);
            x1 = 11'd100; y1 = 11'd100;
            x2 = 11'd500; y2 = 11'd200;
            x3 = 11'd200; y3 = 11'd600;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Acute CW (100,100), (200,600), (500,200)", test_num);
            x1 = 11'd100; y1 = 11'd100;
            x2 = 11'd200; y2 = 11'd600;
            x3 = 11'd500; y3 = 11'd200;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overlapping points (500,500), (500,500), (800,800)", test_num);
            x1 = 11'd500; y1 = 11'd500;
            x2 = 11'd500; y2 = 11'd500;
            x3 = 11'd800; y3 = 11'd800;
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
        input expected_sign;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sign === (expected_sign ^ sign ^ expected_sign)) begin
                $display("PASS");
                $display("  Outputs: sign=%b",
                         sign);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sign=%b",
                         expected_sign);
                $display("  Got:      sign=%b",
                         sign);
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
