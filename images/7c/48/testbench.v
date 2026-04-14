`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] x1;
    reg [9:0] x2;
    reg [9:0] x3;
    reg [9:0] x4;
    reg [8:0] y1;
    reg [8:0] y2;
    reg [8:0] y3;
    reg [8:0] y4;
    wire [6:0] percent_kept;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .y1(y1),
        .y2(y2),
        .y3(y3),
        .y4(y4),
        .percent_kept(percent_kept)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Overlap (100%%)", test_num);


            x1 = 10'd0;   y1 = 9'd0;
            x2 = 10'd100; y2 = 9'd100;
            x3 = 10'd0;   y3 = 9'd0;
            x4 = 10'd100; y4 = 9'd100;
            #1;

            check_outputs(7'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Overlap (0%%)", test_num);


            x1 = 10'd0;   y1 = 9'd0;
            x2 = 10'd50;  y2 = 9'd50;
            x3 = 10'd60;  y3 = 9'd60;
            x4 = 10'd100; y4 = 9'd100;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vertical Half Overlap (50%%)", test_num);


            x1 = 10'd0;   y1 = 9'd0;
            x2 = 10'd100; y2 = 9'd100;
            x3 = 10'd50;  y3 = 9'd0;
            x4 = 10'd150; y4 = 9'd100;
            #1;

            check_outputs(7'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Horizontal Half Overlap (50%%)", test_num);


            x1 = 10'd0;   y1 = 9'd0;
            x2 = 10'd100; y2 = 9'd100;
            x3 = 10'd0;   y3 = 9'd50;
            x4 = 10'd100; y4 = 9'd150;
            #1;

            check_outputs(7'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Corner Quarter Overlap (25%%)", test_num);


            x1 = 10'd0;   y1 = 9'd0;
            x2 = 10'd200; y2 = 9'd200;
            x3 = 10'd100; y3 = 9'd100;
            x4 = 10'd300; y4 = 9'd300;
            #1;

            check_outputs(7'd25);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ROI Inside Larger Clip (100%%)", test_num);


            x1 = 10'd50;  y1 = 9'd50;
            x2 = 10'd60;  y2 = 9'd60;
            x3 = 10'd0;   y3 = 9'd0;
            x4 = 10'd500; y4 = 9'd500;
            #1;

            check_outputs(7'd100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small ROI Strip (10%%)", test_num);


            x1 = 10'd0;   y1 = 9'd0;
            x2 = 10'd100; y2 = 9'd10;
            x3 = 10'd0;   y3 = 9'd0;
            x4 = 10'd10;  y4 = 9'd10;
            #1;

            check_outputs(7'd10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Flipped Coordinates Logic Check", test_num);



            x1 = 10'd100; y1 = 9'd100;
            x2 = 10'd0;   y2 = 9'd0;
            x3 = 10'd0;   y3 = 9'd0;
            x4 = 10'd50;  y4 = 9'd100;
            #1;

            check_outputs(7'd50);
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
        input [6:0] expected_percent_kept;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_percent_kept === (expected_percent_kept ^ percent_kept ^ expected_percent_kept)) begin
                $display("PASS");
                $display("  Outputs: percent_kept=%h",
                         percent_kept);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: percent_kept=%h",
                         expected_percent_kept);
                $display("  Got:      percent_kept=%h",
                         percent_kept);
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
