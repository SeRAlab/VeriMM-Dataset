`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] T;
    reg [15:0] in1;
    reg [15:0] in2;
    wire [15:0] out1;
    wire [15:0] out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .T(T),
        .in1(in1),
        .in2(in2),
        .out1(out1),
        .out2(out2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs within positive range (|in| <= T)", test_num);
            T = 16'sd100;
            in1 = 16'sd50;
            in2 = 16'sd25;
            #1;

            check_outputs(16'sd50, 16'sd25);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs within negative range (|in| <= T)", test_num);
            T = 16'sd100;
            in1 = -16'sd50;
            in2 = -16'sd99;
            #1;

            check_outputs(-16'sd50, -16'sd99);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive saturation (in > T)", test_num);
            T = 16'sd100;
            in1 = 16'sd150;
            in2 = 16'sd500;
            #1;

            check_outputs(16'sd100, 16'sd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative saturation (in < -T)", test_num);
            T = 16'sd100;
            in1 = -16'sd150;
            in2 = -16'sd101;
            #1;

            check_outputs(-16'sd100, -16'sd100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary conditions (in == T, in == -T)", test_num);
            T = 16'sd500;
            in1 = 16'sd500;
            in2 = -16'sd500;
            #1;

            check_outputs(16'sd500, -16'sd500);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed saturation", test_num);
            T = 16'sd10;
            in1 = 16'sd5;
            in2 = -16'sd100;
            #1;

            check_outputs(16'sd5, -16'sd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Extreme signed values", test_num);
            T = 16'sd1000;
            in1 = 16'sd32767;
            in2 = -16'sd32768;
            #1;

            check_outputs(16'sd1000, -16'sd1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero threshold", test_num);
            T = 16'sd0;
            in1 = 16'sd100;
            in2 = -16'sd100;
            #1;

            check_outputs(16'sd0, 16'sd0);
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
        input [15:0] expected_out1;
        input [15:0] expected_out2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2)) begin
                $display("PASS");
                $display("  Outputs: out1=%h, out2=%h",
                         out1, out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h, out2=%h",
                         expected_out1, expected_out2);
                $display("  Got:      out1=%h, out2=%h",
                         out1, out2);
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
