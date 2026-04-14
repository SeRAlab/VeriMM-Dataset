`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 4'h0;
            #1;

            check_outputs(4'hc);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 4'h1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 4'h2;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 4'h3;
            #1;

            check_outputs(4'hb);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 4'h4;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 4'h5;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 4'h6;
            #1;

            check_outputs(4'ha);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 4'h7;
            #1;

            check_outputs(4'hd);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            x = 4'h8;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            x = 4'h9;
            #1;

            check_outputs(4'he);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            x = 4'ha;
            #1;

            check_outputs(4'hf);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            x = 4'hb;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            x = 4'hc;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            x = 4'hd;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            x = 4'he;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            x = 4'hf;
            #1;

            check_outputs(4'h2);
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
