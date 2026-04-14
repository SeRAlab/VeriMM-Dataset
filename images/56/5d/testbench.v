`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [6:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .r(r)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input 4'h0", test_num);
            x = 4'h0;
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input 4'h1", test_num);
            x = 4'h1;
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input 4'h2", test_num);
            x = 4'h2;
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input 4'h3", test_num);
            x = 4'h3;
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input 4'h4", test_num);
            x = 4'h4;
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input 4'h5", test_num);
            x = 4'h5;
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Input 4'h6", test_num);
            x = 4'h6;
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Input 4'h7", test_num);
            x = 4'h7;
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Input 4'h8", test_num);
            x = 4'h8;
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Input 4'h9", test_num);
            x = 4'h9;
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Input 4'hA", test_num);
            x = 4'hA;
            #1;

            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: Input 4'hB", test_num);
            x = 4'hB;
            #1;

            check_outputs(7'h7c);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Testcase %0d: Input 4'hC", test_num);
            x = 4'hC;
            #1;

            check_outputs(7'h39);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Testcase %0d: Input 4'hD", test_num);
            x = 4'hD;
            #1;

            check_outputs(7'h5e);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Testcase %0d: Input 4'hE", test_num);
            x = 4'hE;
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            $display("Testcase %0d: Input 4'hF", test_num);
            x = 4'hF;
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
        input [6:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
