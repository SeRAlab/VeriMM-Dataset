`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [4:0] aluc;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .aluc(aluc),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'h0000000A; b = 32'h00000005; aluc = 5'd0;
            #10;
            $display("Test %0d: Addition (10 + 5)", test_num);
            #1;

            check_outputs(32'h0000000F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'h0000000A; b = 32'h00000004; aluc = 5'd1;
            #10;
            $display("Test %0d: Subtraction (10 - 4)", test_num);
            #1;

            check_outputs(32'h00000006);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'h00000005; b = 32'h0000000A; aluc = 5'd1;
            #10;
            $display("Test %0d: Subtraction (5 - 10)", test_num);
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'hF0F0F0F0; b = 32'hAAAA5555; aluc = 5'd2;
            #10;
            $display("Test %0d: Bitwise AND", test_num);
            #1;

            check_outputs(32'hA0A05050);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'hF0F0F0F0; b = 32'h0000FFFF; aluc = 5'd3;
            #10;
            $display("Test %0d: Bitwise OR", test_num);
            #1;

            check_outputs(32'hF0F0FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'h00000001; b = 32'd4; aluc = 5'd4;
            #10;
            $display("Test %0d: Logical Left Shift", test_num);
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h80000000; b = 32'd1; aluc = 5'd5;
            #10;
            $display("Test %0d: Logical Right Shift", test_num);
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'h80000000; b = 32'd1; aluc = 5'd6;
            #10;
            $display("Test %0d: Arithmetic Right Shift (Negative)", test_num);
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'h40000000; b = 32'd2; aluc = 5'd6;
            #10;
            $display("Test %0d: Arithmetic Right Shift (Positive)", test_num);
            #1;

            check_outputs(32'h10000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; aluc = 5'b11111;
            #10;
            $display("Test %0d: Default case (Result=0)", test_num);
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_result;
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
