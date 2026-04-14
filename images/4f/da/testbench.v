`timescale 1ns/1ps

module Mux8to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    reg [2:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Mux8to1 dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Select bit 0 (High)");
            in = 8'b00000001;
            sel = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Select bit 1 (High)");
            in = 8'b00000010;
            sel = 3'b001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Select bit 2 (High)");
            in = 8'b00000100;
            sel = 3'b010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Select bit 3 (High)");
            in = 8'b00001000;
            sel = 3'b011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Select bit 4 (High)");
            in = 8'b00010000;
            sel = 3'b100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Select bit 5 (High)");
            in = 8'b00100000;
            sel = 3'b101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Select bit 6 (High)");
            in = 8'b01000000;
            sel = 3'b110;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Select bit 7 (High)");
            in = 8'b10000000;
            sel = 3'b111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Select bit 3 (Low) with others High");
            in = 8'b11110111;
            sel = 3'b011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Alternating pattern 01010101, Select bit 0");
            in = 8'b01010101;
            sel = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case 011: Alternating pattern 01010101, Select bit 1");
            in = 8'b01010101;
            sel = 3'b001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case 012: Pattern 10101010, Select bit 7");
            in = 8'b10101010;
            sel = 3'b111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test Case 013: Pattern 10101010, Select bit 6");
            in = 8'b10101010;
            sel = 3'b110;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Test Case 014: All High, Select bit 4");
            in = 8'b11111111;
            sel = 3'b100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Test Case 015: All Low, Select bit 2");
            in = 8'b00000000;
            sel = 3'b010;
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
        $display("Mux8to1 Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
