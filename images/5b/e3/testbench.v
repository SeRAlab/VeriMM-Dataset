`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] b;
    reg x;
    wire [2:0] b0;
    wire [2:0] b1;
    wire [2:0] b2;
    wire [2:0] b3;
    wire [2:0] b4;
    wire [2:0] b5;
    wire [2:0] b6;
    wire [2:0] b7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .x(x),
        .b0(b0),
        .b1(b1),
        .b2(b2),
        .b3(b3),
        .b4(b4),
        .b5(b5),
        .b6(b6),
        .b7(b7)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 0; b = 16'hFFFF;
            #1;

            check_outputs(3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 1; b = 16'h0000;
            #1;

            check_outputs(3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 1; b = 16'h5555;
            #1;

            check_outputs(3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1, 3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 1; b = 16'hAAAA;
            #1;

            check_outputs(3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2, 3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 1; b = 16'hFFFF;
            #1;

            check_outputs(3'd3, 3'd3, 3'd3, 3'd3, 3'd3, 3'd3, 3'd3, 3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 1; b = 16'hC003;
            #1;

            check_outputs(3'd3, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 1; b = 16'h1234;

            #1;


            check_outputs(3'd0, 3'd1, 3'd3, 3'd0, 3'd2, 3'd0, 3'd1, 3'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 1; b = 16'hE4B1;

            #1;


            check_outputs(3'd1, 3'd0, 3'd3, 3'd2, 3'd0, 3'd1, 3'd2, 3'd3);
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
        input [2:0] expected_b0;
        input [2:0] expected_b1;
        input [2:0] expected_b2;
        input [2:0] expected_b3;
        input [2:0] expected_b4;
        input [2:0] expected_b5;
        input [2:0] expected_b6;
        input [2:0] expected_b7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b0 === (expected_b0 ^ b0 ^ expected_b0) &&
                expected_b1 === (expected_b1 ^ b1 ^ expected_b1) &&
                expected_b2 === (expected_b2 ^ b2 ^ expected_b2) &&
                expected_b3 === (expected_b3 ^ b3 ^ expected_b3) &&
                expected_b4 === (expected_b4 ^ b4 ^ expected_b4) &&
                expected_b5 === (expected_b5 ^ b5 ^ expected_b5) &&
                expected_b6 === (expected_b6 ^ b6 ^ expected_b6) &&
                expected_b7 === (expected_b7 ^ b7 ^ expected_b7)) begin
                $display("PASS");
                $display("  Outputs: b0=%h, b1=%h, b2=%h, b3=%h, b4=%h, b5=%h, b6=%h, b7=%h",
                         b0, b1, b2, b3, b4, b5, b6, b7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b0=%h, b1=%h, b2=%h, b3=%h, b4=%h, b5=%h, b6=%h, b7=%h",
                         expected_b0, expected_b1, expected_b2, expected_b3, expected_b4, expected_b5, expected_b6, expected_b7);
                $display("  Got:      b0=%h, b1=%h, b2=%h, b3=%h, b4=%h, b5=%h, b6=%h, b7=%h",
                         b0, b1, b2, b3, b4, b5, b6, b7);
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
