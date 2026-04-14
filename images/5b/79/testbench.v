`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    reg [7:0] inB;
    reg [5:0] inOp;
    wire [7:0] tout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .inB(inB),
        .inOp(inOp),
        .tout(tout)
    );
    task testcase001;

        begin
            $display("Testcase 001: Addition (10 + 20)");
            test_num = 1;
            in = 8'd10;
            inB = 8'd20;
            inOp = 6'd0;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Subtraction (50 - 20)");
            test_num = 2;
            in = 8'd50;
            inB = 8'd20;
            inOp = 6'd1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Bitwise AND");
            test_num = 3;
            in = 8'b1100_1100;
            inB = 8'b1010_1010;
            inOp = 6'd2;
            #1;

            check_outputs(8'b1000_1000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Bitwise OR");
            test_num = 4;
            in = 8'b1100_1100;
            inB = 8'b1010_1010;
            inOp = 6'd3;
            #1;

            check_outputs(8'b1110_1110);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Bitwise XOR");
            test_num = 5;
            in = 8'b1100_1100;
            inB = 8'b1010_1010;
            inOp = 6'd4;
            #1;

            check_outputs(8'b0110_0110);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Logical Shift Right (8'h80 >> 1)");
            test_num = 6;
            in = 8'h80;
            inB = 8'd1;
            inOp = 6'd5;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Arithmetic Shift Right Positive (8'h40 >>> 1)");
            test_num = 7;
            in = 8'h40;
            inB = 8'd1;
            inOp = 6'd6;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Arithmetic Shift Right Negative (8'h80 >>> 1)");
            test_num = 8;
            in = 8'h80;
            inB = 8'd1;
            inOp = 6'd6;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Addition with Negative Result");
            test_num = 9;
            in = 8'sd5;
            inB = -8'sd10;
            inOp = 6'd0;
            #1;

            check_outputs(-8'sd5);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Unsupported Opcode");
            test_num = 10;
            in = 8'hFF;
            inB = 8'hFF;
            inOp = 6'h3F;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_tout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tout === (expected_tout ^ tout ^ expected_tout)) begin
                $display("PASS");
                $display("  Outputs: tout=%h",
                         tout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tout=%h",
                         expected_tout);
                $display("  Got:      tout=%h",
                         tout);
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
