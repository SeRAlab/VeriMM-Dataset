`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en_in_n;
    reg [7:0] v;
    wire en_out;
    wire gs;
    wire [2:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en_in_n(en_in_n),
        .v(v),
        .en_out(en_out),
        .gs(gs),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            en_in_n = 1'b1;
            v = 8'hFF;
            $display("Test %0d: Module Disabled (en_in_n=1, v=0xFF)", test_num);
            #1;

            check_outputs(1'b1, 1'b1, 3'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            en_in_n = 1'b0;
            v = 8'hFF;
            $display("Test %0d: Module Enabled, No inputs active (en_in_n=0, v=0xFF)", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 3'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            en_in_n = 1'b0;
            v = 8'b11111110;
            $display("Test %0d: Bit 0 active (en_in_n=0, v=0xFE)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            en_in_n = 1'b0;
            v = 8'b11111101;
            $display("Test %0d: Bit 1 active (en_in_n=0, v=0xFD)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            en_in_n = 1'b0;
            v = 8'b11111011;
            $display("Test %0d: Bit 2 active (en_in_n=0, v=0xFB)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            en_in_n = 1'b0;
            v = 8'b11110111;
            $display("Test %0d: Bit 3 active (en_in_n=0, v=0xF7)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            en_in_n = 1'b0;
            v = 8'b11101111;
            $display("Test %0d: Bit 4 active (en_in_n=0, v=0xEF)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            en_in_n = 1'b0;
            v = 8'b11011111;
            $display("Test %0d: Bit 5 active (en_in_n=0, v=0xDF)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd5);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            en_in_n = 1'b0;
            v = 8'b10111111;
            $display("Test %0d: Bit 6 active (en_in_n=0, v=0xBF)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd6);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            en_in_n = 1'b0;
            v = 8'b01111111;
            $display("Test %0d: Bit 7 active (en_in_n=0, v=0x7F)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd7);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            en_in_n = 1'b0;
            v = 8'b00000000;
            $display("Test %0d: Priority Check - All bits zero (v=0x00)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            en_in_n = 1'b0;
            v = 8'b11110000;
            $display("Test %0d: Priority Check - Low nibble zero (v=0xF0)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            en_in_n = 1'b0;
            v = 8'b00001111;
            $display("Test %0d: Priority Check - High nibble zero (v=0x0F)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd4);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            en_in_n = 1'b0;
            v = 8'b10101010;
            $display("Test %0d: Priority Check - Alternating bits (v=0xAA)", test_num);
            #1;

            check_outputs(1'b1, 1'b0, 3'd0);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            en_in_n = 1'b1;
            v = 8'h00;
            $display("Test %0d: Disabled Override (en_in_n=1, v=0x00)", test_num);
            #1;

            check_outputs(1'b1, 1'b1, 3'd7);
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
        input expected_en_out;
        input expected_gs;
        input [2:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_en_out === (expected_en_out ^ en_out ^ expected_en_out) &&
                expected_gs === (expected_gs ^ gs ^ expected_gs) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: en_out=%b, gs=%b, y=%h",
                         en_out, gs, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en_out=%b, gs=%b, y=%h",
                         expected_en_out, expected_gs, expected_y);
                $display("  Got:      en_out=%b, gs=%b, y=%h",
                         en_out, gs, y);
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
