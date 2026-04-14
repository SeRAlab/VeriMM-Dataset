`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] alu_in1;
    reg [15:0] alu_in2;
    reg [1:0] alu_sel;
    wire [15:0] alu_out;
    wire ovf;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_in1(alu_in1),
        .alu_in2(alu_in2),
        .alu_sel(alu_sel),
        .alu_out(alu_out),
        .ovf(ovf),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (5 + 10)", test_num);
            alu_in1 = 16'h0005;
            alu_in2 = 16'h000A;
            alu_sel = 2'b00;
            #1;

            check_outputs(16'h000F, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition (0 + 0)", test_num);
            alu_in1 = 16'h0000;
            alu_in2 = 16'h0000;
            alu_sel = 2'b00;
            #1;

            check_outputs(16'h0000, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Positive Overflow", test_num);
            alu_in1 = 16'h7FFF;
            alu_in2 = 16'h0001;
            alu_sel = 2'b00;
            #1;

            check_outputs(16'h8000, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Negative Overflow", test_num);
            alu_in1 = 16'h8000;
            alu_in2 = 16'h8000;
            alu_sel = 2'b00;
            #1;

            check_outputs(16'h0000, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction (20 - 5)", test_num);
            alu_in1 = 16'h0014;
            alu_in2 = 16'h0005;
            alu_sel = 2'b01;
            #1;

            check_outputs(16'h000F, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Result Zero", test_num);
            alu_in1 = 16'h1234;
            alu_in2 = 16'h1234;
            alu_sel = 2'b01;
            #1;

            check_outputs(16'h0000, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Positive Overflow", test_num);
            alu_in1 = 16'h7FFF;
            alu_in2 = 16'hFFFF;
            alu_sel = 2'b01;
            #1;

            check_outputs(16'h8000, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Negative Overflow", test_num);
            alu_in1 = 16'h8000;
            alu_in2 = 16'h0001;
            alu_sel = 2'b01;
            #1;

            check_outputs(16'h7FFF, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment (100 -> 101)", test_num);
            alu_in1 = 16'd100;
            alu_in2 = 16'hXXXX;
            alu_sel = 2'b10;
            #1;

            check_outputs(16'd101, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment Overflow", test_num);
            alu_in1 = 16'h7FFF;
            alu_sel = 2'b10;
            #1;

            check_outputs(16'h8000, 1'b1, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment Wrap to Zero", test_num);
            alu_in1 = 16'hFFFF;
            alu_sel = 2'b10;
            #1;

            check_outputs(16'h0000, 1'b0, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Addition No Overflow", test_num);
            alu_in1 = 16'h2000;
            alu_in2 = 16'h2000;
            alu_sel = 2'b00;
            #1;

            check_outputs(16'h4000, 1'b0, 1'b0);
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
        input [15:0] expected_alu_out;
        input expected_ovf;
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out) &&
                expected_ovf === (expected_ovf ^ ovf ^ expected_ovf) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h, ovf=%b, z=%b",
                         alu_out, ovf, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h, ovf=%b, z=%b",
                         expected_alu_out, expected_ovf, expected_z);
                $display("  Got:      alu_out=%h, ovf=%b, z=%b",
                         alu_out, ovf, z);
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
