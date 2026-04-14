`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] nibble;
    wire [6:0] sseg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .nibble(nibble),
        .sseg(sseg)
    );
    task testcase001;

        begin
            test_num = 1;
            nibble = 4'h0;
            $display("Test %0d: Input 4'h0", test_num);
            #1;

            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            nibble = 4'h1;
            $display("Test %0d: Input 4'h1", test_num);
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            nibble = 4'h2;
            $display("Test %0d: Input 4'h2", test_num);
            #1;

            check_outputs(7'h5B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            nibble = 4'h3;
            $display("Test %0d: Input 4'h3", test_num);
            #1;

            check_outputs(7'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            nibble = 4'h4;
            $display("Test %0d: Input 4'h4", test_num);
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            nibble = 4'h5;
            $display("Test %0d: Input 4'h5", test_num);
            #1;

            check_outputs(7'h6D);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            nibble = 4'h6;
            $display("Test %0d: Input 4'h6", test_num);
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            nibble = 4'h7;
            $display("Test %0d: Input 4'h7", test_num);
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            nibble = 4'h8;
            $display("Test %0d: Input 4'h8", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            nibble = 4'h9;
            $display("Test %0d: Input 4'h9", test_num);
            #1;

            check_outputs(7'h6F);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            nibble = 4'hA;
            $display("Test %0d: Input 4'hA", test_num);
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            nibble = 4'hb;
            $display("Test %0d: Input 4'hb", test_num);
            #1;

            check_outputs(7'h7C);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            nibble = 4'hC;
            $display("Test %0d: Input 4'hC", test_num);
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            nibble = 4'hd;
            $display("Test %0d: Input 4'hd", test_num);
            #1;

            check_outputs(7'h5E);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            nibble = 4'hE;
            $display("Test %0d: Input 4'hE", test_num);
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            nibble = 4'hF;
            $display("Test %0d: Input 4'hF", test_num);
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
        input [6:0] expected_sseg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sseg === (expected_sseg ^ sseg ^ expected_sseg)) begin
                $display("PASS");
                $display("  Outputs: sseg=%h",
                         sseg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sseg=%h",
                         expected_sseg);
                $display("  Got:      sseg=%h",
                         sseg);
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
