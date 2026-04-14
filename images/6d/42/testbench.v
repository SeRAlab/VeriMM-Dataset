`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [6:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .led(led)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Input 0");
            in = 4'h0;
            #10;
            #1;

            check_outputs(7'b0111111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Input 1");
            in = 4'h1;
            #10;
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Input 2");
            in = 4'h2;
            #10;
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Input 3");
            in = 4'h3;
            #10;
            #1;

            check_outputs(7'b1001111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Input 4");
            in = 4'h4;
            #10;
            #1;

            check_outputs(7'b1100110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Input 5");
            in = 4'h5;
            #10;
            #1;

            check_outputs(7'b1101101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Input 6");
            in = 4'h6;
            #10;
            #1;

            check_outputs(7'b1111101);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Input 7");
            in = 4'h7;
            #10;
            #1;

            check_outputs(7'b0000111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Input 8");
            in = 4'h8;
            #10;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Input 9");
            in = 4'h9;
            #10;
            #1;

            check_outputs(7'b1101111);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case 011: Input A");
            in = 4'hA;
            #10;
            #1;

            check_outputs(7'b1110111);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case 012: Input B");
            in = 4'hB;
            #10;
            #1;

            check_outputs(7'b1111100);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test Case 013: Input C");
            in = 4'hC;
            #10;
            #1;

            check_outputs(7'b0111001);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Test Case 014: Input D");
            in = 4'hD;
            #10;
            #1;

            check_outputs(7'b1011110);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Test Case 015: Input E");
            in = 4'hE;
            #10;
            #1;

            check_outputs(7'b1111001);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            $display("Test Case 016: Input F");
            in = 4'hF;
            #10;
            #1;

            check_outputs(7'b1110001);
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
        input [6:0] expected_led;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%h",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h",
                         expected_led);
                $display("  Got:      led=%h",
                         led);
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
