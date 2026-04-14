`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg mul;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .mul(mul),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mul=0, random inputs (Result should be 0)", test_num);
            a = 8'hA5;
            b = 8'h5A;
            mul = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mul=1, a=0, b=0", test_num);
            a = 8'h00;
            b = 8'h00;
            mul = 1'b1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mul=1, a=1, b=1", test_num);
            a = 8'h01;
            b = 8'h01;
            mul = 1'b1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mul=1, a=255, b=1", test_num);
            a = 8'hFF;
            b = 8'h01;
            mul = 1'b1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mul=1, a=255, b=255 (Max product)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            mul = 1'b1;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mul=1, a=128, b=2", test_num);
            a = 8'h80;
            b = 8'h02;
            mul = 1'b1;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mul=1, a=15, b=15", test_num);
            a = 8'h0F;
            b = 8'h0F;
            mul = 1'b1;
            #1;

            check_outputs(16'h00E1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mul=1, a=0xAA, b=0x55", test_num);
            a = 8'hAA;
            b = 8'h55;
            mul = 1'b1;
            #1;

            check_outputs(16'h3872);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mul switching from 1 to 0", test_num);
            a = 8'hFF;
            b = 8'hFF;
            mul = 1'b1;
            #2;
            mul = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: mul=1, a=10, b=20", test_num);
            a = 8'd10;
            b = 8'd20;
            mul = 1'b1;
            #1;

            check_outputs(16'd200);
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
