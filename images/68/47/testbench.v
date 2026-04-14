`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] binary;
    reg dir;
    wire [4:0] gray;
    wire [4:0] rotated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .dir(dir),
        .gray(gray),
        .rotated(rotated)
    );
    task testcase001;

        begin
            test_num = 1;
            binary = 5'b00000;
            dir = 1'b0;

            #1;


            check_outputs(5'b00000, 5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            binary = 5'b00000;
            dir = 1'b1;

            #1;


            check_outputs(5'b00000, 5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            binary = 5'b00001;
            dir = 1'b0;


            #1;



            check_outputs(5'b00001, 5'b00010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            binary = 5'b00001;
            dir = 1'b1;


            #1;



            check_outputs(5'b00001, 5'b10000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            binary = 5'b11111;
            dir = 1'b0;


            #1;



            check_outputs(5'b10000, 5'b00001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            binary = 5'b11111;
            dir = 1'b1;


            #1;



            check_outputs(5'b10000, 5'b01000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            binary = 5'b10000;
            dir = 1'b0;


            #1;



            check_outputs(5'b11000, 5'b10001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            binary = 5'b10000;
            dir = 1'b1;


            #1;



            check_outputs(5'b11000, 5'b01100);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            binary = 5'b01010;
            dir = 1'b0;


            #1;



            check_outputs(5'b01111, 5'b11110);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            binary = 5'b10101;
            dir = 1'b1;


            #1;



            check_outputs(5'b11111, 5'b11111);
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
        input [4:0] expected_gray;
        input [4:0] expected_rotated;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray === (expected_gray ^ gray ^ expected_gray) &&
                expected_rotated === (expected_rotated ^ rotated ^ expected_rotated)) begin
                $display("PASS");
                $display("  Outputs: gray=%h, rotated=%h",
                         gray, rotated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h, rotated=%h",
                         expected_gray, expected_rotated);
                $display("  Got:      gray=%h, rotated=%h",
                         gray, rotated);
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
