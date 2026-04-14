`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] digit;
    wire [6:0] seven_segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .digit(digit),
        .seven_segments(seven_segments)
    );
    task testcase001;

        begin
            test_num = 1;
            digit = 4'h0;
            #10;
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            digit = 4'h1;
            #10;
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            digit = 4'h2;
            #10;
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            digit = 4'h3;
            #10;
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            digit = 4'h4;
            #10;
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            digit = 4'h5;
            #10;
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            digit = 4'h6;
            #10;
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            digit = 4'h7;
            #10;
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            digit = 4'h8;
            #10;
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            digit = 4'h9;
            #10;
            #1;

            check_outputs(7'h6F);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            digit = 4'hA;
            #10;
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            digit = 4'hB;
            #10;
            #1;

            check_outputs(7'h7C);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            digit = 4'hC;
            #10;
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            digit = 4'hD;
            #10;
            #1;

            check_outputs(7'h5E);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            digit = 4'hE;
            #10;
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            digit = 4'hF;
            #10;
            #1;

            check_outputs(7'h71);
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
        input [6:0] expected_seven_segments;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seven_segments === (expected_seven_segments ^ seven_segments ^ expected_seven_segments)) begin
                $display("PASS");
                $display("  Outputs: seven_segments=%h",
                         seven_segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seven_segments=%h",
                         expected_seven_segments);
                $display("  Got:      seven_segments=%h",
                         seven_segments);
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
