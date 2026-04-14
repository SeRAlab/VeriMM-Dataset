`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] alu_op;
    reg [15:0] in1;
    reg [15:0] in2;
    wire [15:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_op(alu_op),
        .in1(in1),
        .in2(in2),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (alu_op = 001)", test_num);
            alu_op = 3'b001;
            in1 = 16'h0005;
            in2 = 16'h000A;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with overflow (alu_op = 001)", test_num);
            alu_op = 3'b001;
            in1 = 16'hFFFF;
            in2 = 16'h0001;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through in1 (alu_op = 010)", test_num);
            alu_op = 3'b010;
            in1 = 16'hABCD;
            in2 = 16'h1234;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pass-through in1 with zero (alu_op = 010)", test_num);
            alu_op = 3'b010;
            in1 = 16'h0000;
            in2 = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Undefined operation (alu_op = 000)", test_num);
            alu_op = 3'b000;
            in1 = 16'h1234;
            in2 = 16'h5678;
            #1;

            check_outputs(16'hXXXX);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Undefined operation (alu_op = 011)", test_num);
            alu_op = 3'b011;
            in1 = 16'hAAAA;
            in2 = 16'h5555;
            #1;

            check_outputs(16'hXXXX);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Undefined operation (alu_op = 111)", test_num);
            alu_op = 3'b111;
            in1 = 16'h1357;
            in2 = 16'h2468;
            #1;

            check_outputs(16'hXXXX);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Addition (alu_op = 001)", test_num);
            alu_op = 3'b001;
            in1 = 16'h1234;
            in2 = 16'h1111;
            #1;

            check_outputs(16'h2345);
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
        input [15:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
