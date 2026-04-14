`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] int_data;
    wire [7:0] seg_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .int_data(int_data),
        .seg_data(seg_data)
    );
    task testcase000;

        begin
            int_data = 4'h0;
            $display("Testcase 000: Input 0x0");
            #1;

            check_outputs(8'h3f);
        end
        endtask

    task testcase001;

        begin
            int_data = 4'h1;
            $display("Testcase 001: Input 0x1");
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase002;

        begin
            int_data = 4'h2;
            $display("Testcase 002: Input 0x2");
            #1;

            check_outputs(8'h5b);
        end
        endtask

    task testcase003;

        begin
            int_data = 4'h3;
            $display("Testcase 003: Input 0x3");
            #1;

            check_outputs(8'h4f);
        end
        endtask

    task testcase004;

        begin
            int_data = 4'h4;
            $display("Testcase 004: Input 0x4");
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase005;

        begin
            int_data = 4'h5;
            $display("Testcase 005: Input 0x5");
            #1;

            check_outputs(8'h6d);
        end
        endtask

    task testcase006;

        begin
            int_data = 4'h6;
            $display("Testcase 006: Input 0x6");
            #1;

            check_outputs(8'h7d);
        end
        endtask

    task testcase007;

        begin
            int_data = 4'h7;
            $display("Testcase 007: Input 0x7");
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase008;

        begin
            int_data = 4'h8;
            $display("Testcase 008: Input 0x8");
            #1;

            check_outputs(8'h7f);
        end
        endtask

    task testcase009;

        begin
            int_data = 4'h9;
            $display("Testcase 009: Input 0x9");
            #1;

            check_outputs(8'h6f);
        end
        endtask

    task testcase010;

        begin
            int_data = 4'hA;
            $display("Testcase 010: Input 0xA");
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase011;

        begin
            int_data = 4'hB;
            $display("Testcase 011: Input 0xB");
            #1;

            check_outputs(8'h7c);
        end
        endtask

    task testcase012;

        begin
            int_data = 4'hC;
            $display("Testcase 012: Input 0xC");
            #1;

            check_outputs(8'h39);
        end
        endtask

    task testcase013;

        begin
            int_data = 4'hD;
            $display("Testcase 013: Input 0xD");
            #1;

            check_outputs(8'h5e);
        end
        endtask

    task testcase014;

        begin
            int_data = 4'hE;
            $display("Testcase 014: Input 0xE");
            #1;

            check_outputs(8'h79);
        end
        endtask

    task testcase015;

        begin
            int_data = 4'hF;
            $display("Testcase 015: Input 0xF");
            #1;

            check_outputs(8'h71);
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


        testcase000();
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
        testcase014();
        testcase015();
        
        
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
        input [7:0] expected_seg_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_data === (expected_seg_data ^ seg_data ^ expected_seg_data)) begin
                $display("PASS");
                $display("  Outputs: seg_data=%h",
                         seg_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_data=%h",
                         expected_seg_data);
                $display("  Got:      seg_data=%h",
                         seg_data);
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
