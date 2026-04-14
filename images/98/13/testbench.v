`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] IN;
    reg select;
    wire [6:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN(IN),
        .select(select),
        .OUT(OUT)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select High, Input 0");
            test_num = 1;
            select = 1'b1;
            IN = 4'd0;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select High, Input 1");
            test_num = 2;
            select = 1'b1;
            IN = 4'd1;
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select High, Input 2");
            test_num = 3;
            select = 1'b1;
            IN = 4'd2;
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select High, Input 3");
            test_num = 4;
            select = 1'b1;
            IN = 4'd3;
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select High, Input 4");
            test_num = 5;
            select = 1'b1;
            IN = 4'd4;
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select High, Input 5");
            test_num = 6;
            select = 1'b1;
            IN = 4'd5;
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Select High, Input 6");
            test_num = 7;
            select = 1'b1;
            IN = 4'd6;
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Select High, Input 7");
            test_num = 8;
            select = 1'b1;
            IN = 4'd7;
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Select High, Input 8");
            test_num = 9;
            select = 1'b1;
            IN = 4'd8;
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Select High, Input 9");
            test_num = 10;
            select = 1'b1;
            IN = 4'd9;
            #1;

            check_outputs(7'h6F);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Select High, Input 10 (A)");
            test_num = 11;
            select = 1'b1;
            IN = 4'd10;
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Select High, Input 11 (b)");
            test_num = 12;
            select = 1'b1;
            IN = 4'd11;
            #1;

            check_outputs(7'h7C);
        end
        endtask

    task testcase013;

        begin
            $display("Testcase 013: Select High, Input 12 (C)");
            test_num = 13;
            select = 1'b1;
            IN = 4'd12;
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            $display("Testcase 014: Select High, Input 13 (d)");
            test_num = 14;
            select = 1'b1;
            IN = 4'd13;
            #1;

            check_outputs(7'h5E);
        end
        endtask

    task testcase015;

        begin
            $display("Testcase 015: Select High, Input 14 (E)");
            test_num = 15;
            select = 1'b1;
            IN = 4'd14;
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            $display("Testcase 016: Select High, Input 15 (F)");
            test_num = 16;
            select = 1'b1;
            IN = 4'd15;
            #1;

            check_outputs(7'h71);
        end
        endtask

    task testcase017;

        begin
            $display("Testcase 017: Select Low (Blanking), Input 0");
            test_num = 17;
            select = 1'b0;
            IN = 4'd0;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase018;

        begin
            $display("Testcase 018: Select Low (Blanking), Input 8");
            test_num = 18;
            select = 1'b0;
            IN = 4'd8;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase019;

        begin
            $display("Testcase 019: Select Low (Blanking), Input 15");
            test_num = 19;
            select = 1'b0;
            IN = 4'd15;
            #1;

            check_outputs(7'h00);
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
        testcase016();
        testcase017();
        testcase018();
        testcase019();
        
        
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
        input [6:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
