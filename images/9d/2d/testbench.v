`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] h_cnt;
    reg valid;
    wire [3:0] vgaBlue;
    wire [3:0] vgaGreen;
    wire [3:0] vgaRed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h_cnt(h_cnt),
        .valid(valid),
        .vgaBlue(vgaBlue),
        .vgaGreen(vgaGreen),
        .vgaRed(vgaRed)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: valid low (h_cnt=200)", test_num);
            valid = 0;
            h_cnt = 200;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: h_cnt in range [0, 127] (h_cnt=50)", test_num);
            valid = 1;
            h_cnt = 50;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: h_cnt boundary 127 (Black)", test_num);
            valid = 1;
            h_cnt = 127;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: h_cnt boundary 128 (Blue)", test_num);
            valid = 1;
            h_cnt = 128;

            #1;


            check_outputs(4'hF, 4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: h_cnt boundary 255 (Blue)", test_num);
            valid = 1;
            h_cnt = 255;

            #1;


            check_outputs(4'hF, 4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: h_cnt boundary 256 (Red)", test_num);
            valid = 1;
            h_cnt = 256;

            #1;


            check_outputs(4'h0, 4'h0, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: h_cnt boundary 383 (Red)", test_num);
            valid = 1;
            h_cnt = 383;

            #1;


            check_outputs(4'h0, 4'h0, 4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: h_cnt boundary 384 (Green)", test_num);
            valid = 1;
            h_cnt = 384;

            #1;


            check_outputs(4'h0, 4'hF, 4'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: h_cnt boundary 511 (Green)", test_num);
            valid = 1;
            h_cnt = 511;

            #1;


            check_outputs(4'h0, 4'hF, 4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: h_cnt boundary 512 (White)", test_num);
            valid = 1;
            h_cnt = 512;

            #1;


            check_outputs(4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: h_cnt boundary 639 (White)", test_num);
            valid = 1;
            h_cnt = 639;

            #1;


            check_outputs(4'hF, 4'hF, 4'hF);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: h_cnt boundary 640 (Beyond 640, Black)", test_num);
            valid = 1;
            h_cnt = 640;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Testcase %0d: h_cnt far beyond range (h_cnt=1023)", test_num);
            valid = 1;
            h_cnt = 1023;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0);
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
        testcase013();
        
        
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
        input [3:0] expected_vgaBlue;
        input [3:0] expected_vgaGreen;
        input [3:0] expected_vgaRed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vgaBlue === (expected_vgaBlue ^ vgaBlue ^ expected_vgaBlue) &&
                expected_vgaGreen === (expected_vgaGreen ^ vgaGreen ^ expected_vgaGreen) &&
                expected_vgaRed === (expected_vgaRed ^ vgaRed ^ expected_vgaRed)) begin
                $display("PASS");
                $display("  Outputs: vgaBlue=%h, vgaGreen=%h, vgaRed=%h",
                         vgaBlue, vgaGreen, vgaRed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vgaBlue=%h, vgaGreen=%h, vgaRed=%h",
                         expected_vgaBlue, expected_vgaGreen, expected_vgaRed);
                $display("  Got:      vgaBlue=%h, vgaGreen=%h, vgaRed=%h",
                         vgaBlue, vgaGreen, vgaRed);
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
