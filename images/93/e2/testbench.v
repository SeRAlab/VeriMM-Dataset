`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [33:0] a;
    reg [33:0] b;
    reg [33:0] c;
    wire [33:0] fma;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .fma(fma)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 34'sd0;
            b = 34'sd0;
            c = 34'sd0;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(34'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 34'sd100;
            b = 34'sd20;
            c = 34'sd5;
            $display("Test %0d: Simple Positive (100 + 20*5)", test_num);
            #1;

            check_outputs(34'sd200);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 34'sd500;
            b = 34'sd10;
            c = -34'sd50;
            $display("Test %0d: Negative Product (500 + 10*-50)", test_num);
            #1;

            check_outputs(34'sd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 34'sd10;
            b = -34'sd8;
            c = -34'sd8;
            $display("Test %0d: Two Negative Multipliers (10 + -8*-8)", test_num);
            #1;

            check_outputs(34'sd74);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = -34'sd1000;
            b = 34'sd25;
            c = 34'sd4;
            $display("Test %0d: Negative 'a' (-1000 + 25*4)", test_num);
            #1;

            check_outputs(-34'sd900);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 34'h1FFFFFFFF;
            b = 34'sd1;
            c = 34'sd0;
            $display("Test %0d: Max Positive 'a'", test_num);
            #1;

            check_outputs(34'h1FFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 34'h200000000;
            b = 34'sd1;
            c = 34'sd0;
            $display("Test %0d: Min Negative 'a'", test_num);
            #1;

            check_outputs(34'h200000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 34'sd15;
            b = 34'h20000;
            c = 34'h20000;
            $display("Test %0d: Product Truncation (15 + 2^34)", test_num);


            #1;



            check_outputs(34'sd15);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = -34'sd1;
            b = -34'sd1;
            c = -34'sd1;
            $display("Test %0d: All Negative (-1 + -1*-1)", test_num);
            #1;

            check_outputs(34'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 34'h1FFFFFFFF;
            b = 34'sd2;
            c = 34'sd1;
            $display("Test %0d: Addition Overflow (MaxPos + 2)", test_num);



            #1;




            check_outputs(34'h200000001);
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
        input [33:0] expected_fma;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fma === (expected_fma ^ fma ^ expected_fma)) begin
                $display("PASS");
                $display("  Outputs: fma=%h",
                         fma);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fma=%h",
                         expected_fma);
                $display("  Got:      fma=%h",
                         fma);
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
