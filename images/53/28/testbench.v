`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] d;
    reg [3:0] e;
    reg [1:0] f;
    wire [3:0] g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .e(e),
        .f(f),
        .g(g)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            d = 4'h3; e = 4'h4; f = 2'd0;
            $display("Test Case %0d: Addition (3 + 4)", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            d = 4'hF; e = 4'h1; f = 2'd0;
            $display("Test Case %0d: Addition Overflow (15 + 1)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            d = 4'hA; e = 4'h3; f = 2'd1;
            $display("Test Case %0d: Subtraction (10 - 3)", test_num);
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            d = 4'h0; e = 4'h1; f = 2'd1;
            $display("Test Case %0d: Subtraction Underflow (0 - 1)", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            d = 4'b1100; e = 4'b1010; f = 2'd2;
            $display("Test Case %0d: Bitwise AND (1100 & 1010)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            d = 4'b0101; e = 4'b1010; f = 2'd2;
            $display("Test Case %0d: Bitwise AND (0101 & 1010)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            d = 4'h0; e = 4'h0; f = 2'd0;
            $display("Test Case %0d: Addition (0 + 0)", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            d = 4'h5; e = 4'h5; f = 2'd1;
            $display("Test Case %0d: Subtraction (5 - 5)", test_num);
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_g;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g === (expected_g ^ g ^ expected_g)) begin
                $display("PASS");
                $display("  Outputs: g=%h",
                         g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%h",
                         expected_g);
                $display("  Got:      g=%h",
                         g);
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
