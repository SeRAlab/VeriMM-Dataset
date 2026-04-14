`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] rgb_888;
    wire [15:0] rgb_565;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rgb_888(rgb_888),
        .rgb_565(rgb_565)
    );
    task testcase001;

        begin
            $display("Testcase 001: All Zeros (Black)");
            test_num = 1;
            rgb_888 = 24'h000000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones (White)");
            test_num = 2;
            rgb_888 = 24'hFFFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Pure Red (Full)");
            test_num = 3;
            rgb_888 = 24'hFF0000;
            #1;

            check_outputs(16'hF800);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Pure Green (Full)");
            test_num = 4;
            rgb_888 = 24'h00FF00;
            #1;

            check_outputs(16'h07E0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Pure Blue (Full)");
            test_num = 5;
            rgb_888 = 24'h0000FF;
            #1;

            check_outputs(16'h001F);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Truncation Check (LSB discarding)");



            test_num = 6;
            rgb_888 = 24'h070307;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Truncation Check (MSB boundary)");




            test_num = 7;
            rgb_888 = 24'h080408;
            #1;

            check_outputs(16'h0841);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Mid-range value 1");




            test_num = 8;
            rgb_888 = 24'hAABBCC;
            #1;

            check_outputs(16'hAD79);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Mid-range value 2");




            test_num = 9;
            rgb_888 = 24'h123456;
            #1;

            check_outputs(16'h11AA);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Checkerboard pattern");




            test_num = 10;
            rgb_888 = 24'h55AA55;
            #1;

            check_outputs(16'h554A);
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
        input [15:0] expected_rgb_565;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rgb_565 === (expected_rgb_565 ^ rgb_565 ^ expected_rgb_565)) begin
                $display("PASS");
                $display("  Outputs: rgb_565=%h",
                         rgb_565);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb_565=%h",
                         expected_rgb_565);
                $display("  Got:      rgb_565=%h",
                         rgb_565);
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
