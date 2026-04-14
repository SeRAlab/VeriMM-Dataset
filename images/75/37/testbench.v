`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] control;
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .in1(in1),
        .in2(in2),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            control = 4'b0000;
            in1 = 32'd100;
            in2 = 32'd250;
            #1;

            check_outputs(32'd350, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            control = 4'b0001;
            in1 = 32'd500;
            in2 = 32'd100;
            #1;

            check_outputs(32'd400, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            control = 4'b0001;
            in1 = 32'hFFFF_FFFF;
            in2 = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            control = 4'b0010;
            in1 = 32'hF0F0_AAAA;
            in2 = 32'h0F0F_FFFF;
            #1;

            check_outputs(32'h0000_AAAA, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            control = 4'b0011;
            in1 = 32'h1234_0000;
            in2 = 32'h0000_5678;
            #1;

            check_outputs(32'h1234_5678, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            control = 4'b0100;
            in1 = 32'd10;
            in2 = 32'd20;
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            control = 4'b0100;
            in1 = 32'd50;
            in2 = 32'd20;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            control = 4'b0000;
            in1 = 32'hFFFF_FFFF;
            in2 = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
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
        input [31:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
