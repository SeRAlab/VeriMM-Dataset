`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Chl1;
    reg [7:0] Chl2;
    reg [7:0] Chl3;
    reg [7:0] Chl4;
    reg [11:0] freq1;
    reg [11:0] freq2;
    reg [11:0] freq3;
    reg [11:0] freq4;
    wire [7:0] sound_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Chl1(Chl1),
        .Chl2(Chl2),
        .Chl3(Chl3),
        .Chl4(Chl4),
        .freq1(freq1),
        .freq2(freq2),
        .freq3(freq3),
        .freq4(freq4),
        .sound_out(sound_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All channels active, simple values", test_num);
            Chl1 = 8'd4;
            Chl2 = 8'd8;
            Chl3 = 8'd12;
            Chl4 = 8'd16;
            freq1 = 12'd2;
            freq2 = 12'd5;
            freq3 = 12'd10;
            freq4 = 12'd4095;

            #1;


            check_outputs(8'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Frequency suppression (0 and 1)", test_num);
            Chl1 = 8'd255;
            Chl2 = 8'd255;
            Chl3 = 8'd100;
            Chl4 = 8'd200;
            freq1 = 12'd0;
            freq2 = 12'd1;
            freq3 = 12'd2;
            freq4 = 12'd100;

            #1;


            check_outputs(8'd75);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All frequencies suppressed", test_num);
            Chl1 = 8'hFF;
            Chl2 = 8'hFF;
            Chl3 = 8'hFF;
            Chl4 = 8'hFF;
            freq1 = 12'd0;
            freq2 = 12'd1;
            freq3 = 12'd0;
            freq4 = 12'd1;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum channel values", test_num);
            Chl1 = 8'd255;
            Chl2 = 8'd255;
            Chl3 = 8'd255;
            Chl4 = 8'd255;
            freq1 = 12'd10;
            freq2 = 12'd10;
            freq3 = 12'd10;
            freq4 = 12'd10;

            #1;


            check_outputs(8'd252);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right-shift truncation check", test_num);
            Chl1 = 8'd3;
            Chl2 = 8'd7;
            Chl3 = 8'd11;
            Chl4 = 8'd15;
            freq1 = 12'd2;
            freq2 = 12'd2;
            freq3 = 12'd2;
            freq4 = 12'd2;

            #1;


            check_outputs(8'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single channel active", test_num);
            Chl1 = 8'd0;
            Chl2 = 8'd0;
            Chl3 = 8'd128;
            Chl4 = 8'd0;
            freq1 = 12'd500;
            freq2 = 12'd500;
            freq3 = 12'd500;
            freq4 = 12'd500;

            #1;


            check_outputs(8'd32);
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
        input [7:0] expected_sound_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sound_out === (expected_sound_out ^ sound_out ^ expected_sound_out)) begin
                $display("PASS");
                $display("  Outputs: sound_out=%h",
                         sound_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sound_out=%h",
                         expected_sound_out);
                $display("  Got:      sound_out=%h",
                         sound_out);
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
