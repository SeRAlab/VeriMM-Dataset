`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [15:0] in1;
    reg [15:0] in2;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (10 + 5)", test_num);
            in1 = 16'd10;
            in2 = 16'd5;
            control = 1'b0;
            #10;
            #1;

            check_outputs(16'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Zero (255 + 0)", test_num);
            in1 = 16'd255;
            in2 = 16'd0;
            control = 1'b0;
            #10;
            #1;

            check_outputs(16'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with Overflow (0xFFFF + 1)", test_num);
            in1 = 16'hFFFF;
            in2 = 16'h0001;
            control = 1'b0;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Comparison (5 < 10)", test_num);
            in1 = 16'd5;
            in2 = 16'd10;
            control = 1'b1;
            #10;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Comparison (20 < 10)", test_num);
            in1 = 16'd20;
            in2 = 16'd10;
            control = 1'b1;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Comparison (15 < 15)", test_num);
            in1 = 16'd15;
            in2 = 16'd15;
            control = 1'b1;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large Addition (0x1234 + 0x4321)", test_num);
            in1 = 16'h1234;
            in2 = 16'h4321;
            control = 1'b0;
            #10;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Comparison (0xFFFF < 0x0000)", test_num);
            in1 = 16'hFFFF;
            in2 = 16'h0000;
            control = 1'b1;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Comparison (0x0000 < 0xFFFF)", test_num);
            in1 = 16'h0000;
            in2 = 16'hFFFF;
            control = 1'b1;
            #10;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode Toggle (Same Inputs, Different Control)", test_num);
            in1 = 16'd50;
            in2 = 16'd100;
            control = 1'b0;
            #5;
            control = 1'b1;
            #10;
            #1;

            check_outputs(16'h0001);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
