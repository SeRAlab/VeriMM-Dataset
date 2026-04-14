`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    wire [6:0] a_to_g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .a_to_g(a_to_g)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 0 (Hex 0)", test_num);
            x = 4'h0;
            #1;

            check_outputs(7'b1111110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 1 (Hex 1)", test_num);
            x = 4'h1;
            #1;

            check_outputs(7'b0110000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 2 (Hex 2)", test_num);
            x = 4'h2;
            #1;

            check_outputs(7'b1101101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 3 (Hex 3)", test_num);
            x = 4'h3;
            #1;

            check_outputs(7'b1111001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 4 (Hex 4)", test_num);
            x = 4'h4;
            #1;

            check_outputs(7'b0110011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 5 (Hex 5)", test_num);
            x = 4'h5;
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 6 (Hex 6)", test_num);
            x = 4'h6;
            #1;

            check_outputs(7'b1011111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 7 (Hex 7)", test_num);
            x = 4'h7;
            #1;

            check_outputs(7'b1110000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 8 (Hex 8)", test_num);
            x = 4'h8;
            #1;

            check_outputs(7'b1111111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 9 (Hex 9)", test_num);
            x = 4'h9;
            #1;

            check_outputs(7'b1111011);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 10 (Hex A)", test_num);
            x = 4'hA;
            #1;

            check_outputs(7'b1110111);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 11 (Hex B)", test_num);
            x = 4'hB;
            #1;

            check_outputs(7'b0011111);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 12 (Hex C)", test_num);
            x = 4'hC;
            #1;

            check_outputs(7'b1001110);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 13 (Hex D)", test_num);
            x = 4'hD;
            #1;

            check_outputs(7'b0111101);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 14 (Hex E)", test_num);
            x = 4'hE;
            #1;

            check_outputs(7'b1001111);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input x = 15 (Hex F)", test_num);
            x = 4'hF;
            #1;

            check_outputs(7'b1000111);
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
        input [6:0] expected_a_to_g;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_to_g === (expected_a_to_g ^ a_to_g ^ expected_a_to_g)) begin
                $display("PASS");
                $display("  Outputs: a_to_g=%h",
                         a_to_g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_to_g=%h",
                         expected_a_to_g);
                $display("  Got:      a_to_g=%h",
                         a_to_g);
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
