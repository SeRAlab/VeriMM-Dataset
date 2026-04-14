`timescale 1ns/1ps

module dct_2x2_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] pixel0;
    reg [3:0] pixel1;
    reg [3:0] pixel2;
    reg [3:0] pixel3;
    wire [3:0] dct0;
    wire [3:0] dct1;
    wire [3:0] dct2;
    wire [3:0] dct3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dct_2x2 dut (
        .pixel0(pixel0),
        .pixel1(pixel1),
        .pixel2(pixel2),
        .pixel3(pixel3),
        .dct0(dct0),
        .dct1(dct1),
        .dct2(dct2),
        .dct3(dct3)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: All Zeros");
        pixel0 = 4'd0; pixel1 = 4'd0; pixel2 = 4'd0; pixel3 = 4'd0;
        #1;

        check_outputs(4'h0, 4'h0, 4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: DC Component (Uniform Mid-range)");
        pixel0 = 4'd8; pixel1 = 4'd8; pixel2 = 4'd8; pixel3 = 4'd8;
        #1;

        check_outputs(4'h8, 4'h0, 4'h0, 4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: DC Component (Maximum)");
        pixel0 = 4'd15; pixel1 = 4'd15; pixel2 = 4'd15; pixel3 = 4'd15;
        #1;

        check_outputs(4'hF, 4'h0, 4'h0, 4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Vertical Edges (Stripe)");
        pixel0 = 4'd12; pixel1 = 4'd0; pixel2 = 4'd12; pixel3 = 4'd0;
        #1;

        check_outputs(4'h6, 4'h6, 4'h0, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Horizontal Edges (Stripe)");
        pixel0 = 4'd12; pixel1 = 4'd12; pixel2 = 4'd0; pixel3 = 4'd0;
        #1;

        check_outputs(4'h6, 4'h0, 4'h6, 4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Checkerboard Pattern A");
        pixel0 = 4'd12; pixel1 = 4'd0; pixel2 = 4'd0; pixel3 = 4'd12;
        #1;

        check_outputs(4'h6, 4'h0, 4'h0, 4'h6);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Checkerboard Pattern B (Negative Result)");

        pixel0 = 4'd0; pixel1 = 4'd12; pixel2 = 4'd12; pixel3 = 4'd0;
        #1;

        check_outputs(4'h6, 4'h0, 4'h0, 4'hA);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Single Pixel Active");

        pixel0 = 4'd12; pixel1 = 4'd0; pixel2 = 4'd0; pixel3 = 4'd0;
        #1;

        check_outputs(4'h3, 4'h3, 4'h3, 4'h3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Complex Pattern");





        pixel0 = 4'd12; pixel1 = 4'd4; pixel2 = 4'd8; pixel3 = 4'd0;
        #1;

        check_outputs(4'h6, 4'h4, 4'h2, 4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dct_2x2 Testbench");
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
        input [3:0] expected_dct0;
        input [3:0] expected_dct1;
        input [3:0] expected_dct2;
        input [3:0] expected_dct3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dct0 === (expected_dct0 ^ dct0 ^ expected_dct0) &&
                expected_dct1 === (expected_dct1 ^ dct1 ^ expected_dct1) &&
                expected_dct2 === (expected_dct2 ^ dct2 ^ expected_dct2) &&
                expected_dct3 === (expected_dct3 ^ dct3 ^ expected_dct3)) begin
                $display("PASS");
                $display("  Outputs: dct0=%h, dct1=%h, dct2=%h, dct3=%h",
                         dct0, dct1, dct2, dct3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dct0=%h, dct1=%h, dct2=%h, dct3=%h",
                         expected_dct0, expected_dct1, expected_dct2, expected_dct3);
                $display("  Got:      dct0=%h, dct1=%h, dct2=%h, dct3=%h",
                         dct0, dct1, dct2, dct3);
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
