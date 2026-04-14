`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary;
    wire [6:0] hex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .hex(hex)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 0 (BCD '0')", test_num);
            binary = 8'd0;
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 1 (BCD '1')", test_num);
            binary = 8'd1;
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 2 (BCD '2')", test_num);
            binary = 8'd2;
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 3 (BCD '3')", test_num);
            binary = 8'd3;
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 4 (BCD '4')", test_num);
            binary = 8'd4;
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 5 (BCD '5')", test_num);
            binary = 8'd5;
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 6 (BCD '6')", test_num);
            binary = 8'd6;
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 7 (BCD '7')", test_num);
            binary = 8'd7;
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 8 (BCD '8')", test_num);
            binary = 8'd8;
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 9 (BCD '9')", test_num);
            binary = 8'd9;
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 10 (Invalid Input - Blank)", test_num);
            binary = 8'd10;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Binary = 255 (Invalid Input - Blank)", test_num);
            binary = 8'd255;
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
        input [6:0] expected_hex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex === (expected_hex ^ hex ^ expected_hex)) begin
                $display("PASS");
                $display("  Outputs: hex=%h",
                         hex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex=%h",
                         expected_hex);
                $display("  Got:      hex=%h",
                         hex);
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
