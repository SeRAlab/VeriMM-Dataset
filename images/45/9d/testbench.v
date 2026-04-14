`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_in;
    wire [3:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .gray_out(gray_out)
    );
    task testcase001;

        begin
            test_num = 1;
            binary_in = 4'b0000;
            #1; #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            binary_in = 4'b0001;
            #1; #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            binary_in = 4'b0010;
            #1; #1;
 check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            binary_in = 4'b0011;
            #1; #1;
 check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            binary_in = 4'b0100;
            #1; #1;
 check_outputs(4'b0110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            binary_in = 4'b0101;
            #1; #1;
 check_outputs(4'b0111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            binary_in = 4'b0110;
            #1; #1;
 check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            binary_in = 4'b0111;
            #1; #1;
 check_outputs(4'b0100);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            binary_in = 4'b1000;
            #1; #1;
 check_outputs(4'b1100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            binary_in = 4'b1001;
            #1; #1;
 check_outputs(4'b1101);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            binary_in = 4'b1010;
            #1; #1;
 check_outputs(4'b1111);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            binary_in = 4'b1011;
            #1; #1;
 check_outputs(4'b1110);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            binary_in = 4'b1100;
            #1; #1;
 check_outputs(4'b1010);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            binary_in = 4'b1101;
            #1; #1;
 check_outputs(4'b1011);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            binary_in = 4'b1110;
            #1; #1;
 check_outputs(4'b1001);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            binary_in = 4'b1111;
            #1; #1;
 check_outputs(4'b1000);
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
        input [3:0] expected_gray_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out)) begin
                $display("PASS");
                $display("  Outputs: gray_out=%h",
                         gray_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_out=%h",
                         expected_gray_out);
                $display("  Got:      gray_out=%h",
                         gray_out);
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
