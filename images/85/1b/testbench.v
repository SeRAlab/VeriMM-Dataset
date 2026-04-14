`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] x;
    reg [9:0] y;
    wire [2:0] rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .rgb(rgb)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Outside defined y-range (y=100, x=50)", test_num);
            x = 10'd50;
            y = 10'd100;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal line boundary - Start (y=112, x=10)", test_num);
            x = 10'd10;
            y = 10'd112;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal line intermediate (y=163, x=200)", test_num);
            x = 10'd200;
            y = 10'd163;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal line boundary - End (y=367, x=10)", test_num);
            x = 10'd10;
            y = 10'd367;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper boundary inclusive check (y=368, x=10)", test_num);
            x = 10'd10;
            y = 10'd368;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical line - Middle (y=200, x=51)", test_num);
            x = 10'd51;
            y = 10'd200;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical line - x=0 (y=250, x=0)", test_num);
            x = 10'd0;
            y = 10'd250;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical line strict boundary - lower (y=113, x=102)", test_num);
            x = 10'd102;
            y = 10'd113;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical line strict boundary - upper failure (y=368, x=153)", test_num);
            x = 10'd153;
            y = 10'd368;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Empty space between grid lines (y=120, x=10)", test_num);
            x = 10'd10;
            y = 10'd120;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large X coordinate vertical line (y=200, x=969)", test_num);
            x = 10'd969;
            y = 10'd200;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Intersection point (y=214, x=255)", test_num);
            x = 10'd255;
            y = 10'd214;
            #1;

            check_outputs(3'b111);
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
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_rgb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rgb === (expected_rgb ^ rgb ^ expected_rgb)) begin
                $display("PASS");
                $display("  Outputs: rgb=%h",
                         rgb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb=%h",
                         expected_rgb);
                $display("  Got:      rgb=%h",
                         rgb);
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
