`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] BACKGROUND;
    reg [6:0] X;
    reg [5:0] Y;
    reg [6:0] leftX;
    reg [5:0] topY;
    wire [15:0] oled_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BACKGROUND(BACKGROUND),
        .X(X),
        .Y(Y),
        .leftX(leftX),
        .topY(topY),
        .oled_data(oled_data)
    );
    task testcase001;

        begin
            BACKGROUND = 16'h0000;
            leftX = 7'd20;
            topY = 6'd20;
            X = 7'd0;
            Y = 6'd0;
            #1;

            check_outputs(BACKGROUND);
        end
        endtask

    task testcase002;

        begin
            BACKGROUND = 16'h1234;
            leftX = 7'd10;
            topY = 6'd10;
            X = 7'd11;
            Y = 6'd10;
            #1;

            check_outputs(RED);
        end
        endtask

    task testcase003;

        begin
            BACKGROUND = 16'h0000;
            leftX = 7'd10;
            topY = 6'd10;
            X = 7'd13;
            Y = 6'd12;
            #1;

            check_outputs(RED);
        end
        endtask

    task testcase004;

        begin
            BACKGROUND = 16'hFFFF;
            leftX = 7'd30;
            topY = 6'd20;
            X = 7'd33;
            Y = 6'd25;
            #1;

            check_outputs(RED);
        end
        endtask

    task testcase005;

        begin
            BACKGROUND = 16'hA5A5;
            leftX = 7'd10;
            topY = 6'd10;
            X = 7'd17;
            Y = 6'd11;
            #1;

            check_outputs(BACKGROUND);
        end
        endtask

    task testcase006;

        begin
            BACKGROUND = 16'h0000;
            leftX = 7'd40;
            topY = 6'd5;
            X = 7'd45;
            Y = 6'd5;
            #1;

            check_outputs(RED);
        end
        endtask

    task testcase007;

        begin
            BACKGROUND = 16'h0000;
            leftX = 7'd10;
            topY = 6'd10;
            X = 7'd10;
            Y = 6'd11;
            #1;

            check_outputs(RED);
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
        input [15:0] expected_oled_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oled_data === (expected_oled_data ^ oled_data ^ expected_oled_data)) begin
                $display("PASS");
                $display("  Outputs: oled_data=%h",
                         oled_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oled_data=%h",
                         expected_oled_data);
                $display("  Got:      oled_data=%h",
                         oled_data);
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
