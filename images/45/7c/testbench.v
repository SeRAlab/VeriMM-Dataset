`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [1:0] op;
    wire [15:0] add_out;
    wire [15:0] div_out;
    wire [15:0] mul_out;
    wire [15:0] sub_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .add_out(add_out),
        .div_out(div_out),
        .mul_out(mul_out),
        .sub_out(sub_out)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'sd500; b = 16'sd250; op = 2'b00;
            #1;

            check_outputs(16'sd750, 16'sd0, 16'sd0, 16'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = -16'sd100; b = 16'sd30; op = 2'b00;
            #1;

            check_outputs(-16'sd70, 16'sd0, 16'sd0, 16'sd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'sd1000; b = 16'sd400; op = 2'b01;
            #1;

            check_outputs(16'sd0, 16'sd0, 16'sd0, 16'sd600);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'sd10; b = 16'sd50; op = 2'b01;
            #1;

            check_outputs(16'sd0, 16'sd0, 16'sd0, -16'sd40);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 16'sd20; b = 16'sd30; op = 2'b10;
            #1;

            check_outputs(16'sd0, 16'sd0, 16'sd600, 16'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = -16'sd15; b = 16'sd4; op = 2'b10;
            #1;

            check_outputs(16'sd0, 16'sd0, -16'sd60, 16'sd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 16'sd1000; b = 16'sd25; op = 2'b11;
            #1;

            check_outputs(16'sd0, 16'sd40, 16'sd0, 16'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = -16'sd80; b = 16'sd4; op = 2'b11;
            #1;

            check_outputs(16'sd0, -16'sd20, 16'sd0, 16'sd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 16'sd99; b = 16'sd0; op = 2'b11;
            #1;

            check_outputs(16'sd0, 16'sd0, 16'sd0, 16'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 16'sd32767; b = 16'sd32767; op = 2'b01;
            #1;

            check_outputs(16'sd0, 16'sd0, 16'sd0, 16'sd0);
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
        input [15:0] expected_add_out;
        input [15:0] expected_div_out;
        input [15:0] expected_mul_out;
        input [15:0] expected_sub_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_add_out === (expected_add_out ^ add_out ^ expected_add_out) &&
                expected_div_out === (expected_div_out ^ div_out ^ expected_div_out) &&
                expected_mul_out === (expected_mul_out ^ mul_out ^ expected_mul_out) &&
                expected_sub_out === (expected_sub_out ^ sub_out ^ expected_sub_out)) begin
                $display("PASS");
                $display("  Outputs: add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         add_out, div_out, mul_out, sub_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         expected_add_out, expected_div_out, expected_mul_out, expected_sub_out);
                $display("  Got:      add_out=%h, div_out=%h, mul_out=%h, sub_out=%h",
                         add_out, div_out, mul_out, sub_out);
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
