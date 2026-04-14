`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] col;
    reg [9:0] row;
    wire on_frame;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .col(col),
        .row(row),
        .on_frame(on_frame)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Top-Left Corner (0, 0)", test_num);
            col = 10'd0;
            row = 10'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Bottom-Right Corner (639, 479)", test_num);
            col = 10'd639;
            row = 10'd479;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Horizontal Boundary Out (640, 240)", test_num);
            col = 10'd640;
            row = 10'd240;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Vertical Boundary Out (320, 480)", test_num);
            col = 10'd320;
            row = 10'd480;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Center of Frame (320, 240)", test_num);
            col = 10'd320;
            row = 10'd240;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Max Coordinates (1023, 1023)", test_num);
            col = 10'd1023;
            row = 10'd1023;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Top-Right Corner (639, 0)", test_num);
            col = 10'd639;
            row = 10'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Bottom-Left Corner (0, 479)", test_num);
            col = 10'd0;
            row = 10'd479;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Corner Boundary Out (640, 480)", test_num);
            col = 10'd640;
            row = 10'd480;
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
        input expected_on_frame;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_on_frame === (expected_on_frame ^ on_frame ^ expected_on_frame)) begin
                $display("PASS");
                $display("  Outputs: on_frame=%b",
                         on_frame);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: on_frame=%b",
                         expected_on_frame);
                $display("  Got:      on_frame=%b",
                         on_frame);
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
