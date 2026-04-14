`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [2:0] op;
    wire [15:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            op = 3'b000; a = 16'h1234; b = 16'h1111;
            #10;
            #1;

            check_outputs(16'h2345, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            op = 3'b000; a = 16'hFFFF; b = 16'h0001;
            #10;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            op = 3'b001; a = 16'h0050; b = 16'h0010;
            #10;
            #1;

            check_outputs(16'h0040, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            op = 3'b001; a = 16'hAAAA; b = 16'hAAAA;
            #10;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            op = 3'b010; a = 16'hF0F0; b = 16'hFFFF;
            #10;
            #1;

            check_outputs(16'hF0F0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            op = 3'b011; a = 16'hAAAA; b = 16'h5555;
            #10;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            op = 3'b100; a = 16'h1234; b = 16'h1234;
            #10;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            op = 3'b101; a = 16'h0001; b = 16'h0004;
            #10;
            #1;

            check_outputs(16'h0010, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            op = 3'b110; a = 16'h8000; b = 16'h0001;
            #10;
            #1;

            check_outputs(16'h4000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            op = 3'b111; a = 16'h8000; b = 16'h0002;
            #10;
            #1;

            check_outputs(16'hE000, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            op = 3'b111; a = 16'h4000; b = 16'h0001;
            #10;
            #1;

            check_outputs(16'h2000, 1'b0);
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
