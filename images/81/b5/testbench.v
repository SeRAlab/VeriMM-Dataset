`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] mBlue_b;
    reg [9:0] mGreen_b;
    reg [9:0] mRed_b;
    reg toggle_blue;
    reg toggle_green;
    reg toggle_red;
    wire [9:0] mBlue_a;
    wire [9:0] mGreen_a;
    wire [9:0] mRed_a;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mBlue_b(mBlue_b),
        .mGreen_b(mGreen_b),
        .mRed_b(mRed_b),
        .toggle_blue(toggle_blue),
        .toggle_green(toggle_green),
        .toggle_red(toggle_red),
        .mBlue_a(mBlue_a),
        .mGreen_a(mGreen_a),
        .mRed_a(mRed_a)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Toggles Enabled", test_num);
        mRed_b = 10'h3FF;
        mGreen_b = 10'h2AA;
        mBlue_b = 10'h155;
        toggle_red = 1'b1;
        toggle_green = 1'b1;
        toggle_blue = 1'b1;

        #1;


        check_outputs(10'h155, 10'h2AA, 10'h3FF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Toggles Disabled", test_num);
        mRed_b = 10'h3FF;
        mGreen_b = 10'h2AA;
        mBlue_b = 10'h155;
        toggle_red = 1'b0;
        toggle_green = 1'b0;
        toggle_blue = 1'b0;
        #1;

        check_outputs(10'h000, 10'h000, 10'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Only Red Enabled", test_num);
        mRed_b = 10'h123;
        mGreen_b = 10'h234;
        mBlue_b = 10'h345;
        toggle_red = 1'b1;
        toggle_green = 1'b0;
        toggle_blue = 1'b0;
        #1;

        check_outputs(10'h000, 10'h000, 10'h123);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Only Green Enabled", test_num);
        mRed_b = 10'h123;
        mGreen_b = 10'h234;
        mBlue_b = 10'h345;
        toggle_red = 1'b0;
        toggle_green = 1'b1;
        toggle_blue = 1'b0;
        #1;

        check_outputs(10'h000, 10'h234, 10'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Only Blue Enabled", test_num);
        mRed_b = 10'h123;
        mGreen_b = 10'h234;
        mBlue_b = 10'h345;
        toggle_red = 1'b0;
        toggle_green = 1'b0;
        toggle_blue = 1'b1;
        #1;

        check_outputs(10'h345, 10'h000, 10'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Red and Blue Enabled, Green Disabled", test_num);
        mRed_b = 10'h0F0;
        mGreen_b = 10'h0F0;
        mBlue_b = 10'h0F0;
        toggle_red = 1'b1;
        toggle_green = 1'b0;
        toggle_blue = 1'b1;
        #1;

        check_outputs(10'h0F0, 10'h000, 10'h0F0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Zero Inputs with Toggles Enabled", test_num);
        mRed_b = 10'h000;
        mGreen_b = 10'h000;
        mBlue_b = 10'h000;
        toggle_red = 1'b1;
        toggle_green = 1'b1;
        toggle_blue = 1'b1;
        #1;

        check_outputs(10'h000, 10'h000, 10'h000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Edge Case - Maximum Values with Alternating Toggles", test_num);
        mRed_b = 10'h3FF;
        mGreen_b = 10'h3FF;
        mBlue_b = 10'h3FF;
        toggle_red = 1'b1;
        toggle_green = 1'b0;
        toggle_blue = 1'b1;
        #1;

        check_outputs(10'h3FF, 10'h000, 10'h3FF);
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
        input [9:0] expected_mBlue_a;
        input [9:0] expected_mGreen_a;
        input [9:0] expected_mRed_a;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mBlue_a === (expected_mBlue_a ^ mBlue_a ^ expected_mBlue_a) &&
                expected_mGreen_a === (expected_mGreen_a ^ mGreen_a ^ expected_mGreen_a) &&
                expected_mRed_a === (expected_mRed_a ^ mRed_a ^ expected_mRed_a)) begin
                $display("PASS");
                $display("  Outputs: mBlue_a=%h, mGreen_a=%h, mRed_a=%h",
                         mBlue_a, mGreen_a, mRed_a);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mBlue_a=%h, mGreen_a=%h, mRed_a=%h",
                         expected_mBlue_a, expected_mGreen_a, expected_mRed_a);
                $display("  Got:      mBlue_a=%h, mGreen_a=%h, mRed_a=%h",
                         mBlue_a, mGreen_a, mRed_a);
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
