`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in;
    wire [3:0] bcd0;
    wire [3:0] bcd1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .bcd0(bcd0),
        .bcd1(bcd1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 0 (Minimum Value)", test_num);
            in = 5'd0;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 9 (Single Digit Max)", test_num);
            in = 5'd9;
            #1;

            check_outputs(4'h9, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 10 (Boundary 10s)", test_num);
            in = 5'd10;
            #1;

            check_outputs(4'h0, 4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 15 (Mid 10s)", test_num);
            in = 5'd15;
            #1;

            check_outputs(4'h5, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 19 (Max 10s)", test_num);
            in = 5'd19;
            #1;

            check_outputs(4'h9, 4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 20 (Boundary 20s)", test_num);
            in = 5'd20;
            #1;

            check_outputs(4'h0, 4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 27 (Mid 20s)", test_num);
            in = 5'd27;
            #1;

            check_outputs(4'h7, 4'h2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 31 (Maximum Value for 5-bit)", test_num);
            in = 5'd31;
            #1;

            check_outputs(4'h1, 4'h3);
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
        input [3:0] expected_bcd0;
        input [3:0] expected_bcd1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd0 === (expected_bcd0 ^ bcd0 ^ expected_bcd0) &&
                expected_bcd1 === (expected_bcd1 ^ bcd1 ^ expected_bcd1)) begin
                $display("PASS");
                $display("  Outputs: bcd0=%h, bcd1=%h",
                         bcd0, bcd1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd0=%h, bcd1=%h",
                         expected_bcd0, expected_bcd1);
                $display("  Got:      bcd0=%h, bcd1=%h",
                         bcd0, bcd1);
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
