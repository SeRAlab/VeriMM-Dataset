`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] op;
    reg start;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .op(op),
        .start(start),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        start = 0;
        forever #5 start = ~start;
    end

        task reset_dut;

        begin
            a = 8'h0;
            b = 8'h0;
            op = 2'b00;

            @(negedge start);
            @(posedge start);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge start);
            a = 8'd5;
            b = 8'd3;
            op = 2'b00;
            @(posedge start);
            #1;
            $write("Testcase 001 (Add): ");
            #1;

            check_outputs(8'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge start);
            a = 8'd250;
            b = 8'd10;
            op = 2'b00;
            @(posedge start);
            #1;
            $write("Testcase 002 (Add Overflow): ");
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge start);
            a = 8'd15;
            b = 8'd5;
            op = 2'b01;
            @(posedge start);
            #1;
            $write("Testcase 003 (Sub): ");
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge start);
            a = 8'd5;
            b = 8'd10;
            op = 2'b01;
            @(posedge start);
            #1;
            $write("Testcase 004 (Sub Underflow): ");
            #1;

            check_outputs(8'd251);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge start);
            a = 8'd12;
            b = 8'd4;
            op = 2'b10;
            @(posedge start);
            #1;
            $write("Testcase 005 (Mul): ");
            #1;

            check_outputs(8'd48);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge start);
            a = 8'd64;
            b = 8'd4;
            op = 2'b10;
            @(posedge start);
            #1;
            $write("Testcase 006 (Mul Truncation): ");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(negedge start);
            a = 8'd100;
            b = 8'd4;
            op = 2'b11;
            @(posedge start);
            #1;
            $write("Testcase 007 (Div): ");
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            @(negedge start);
            a = 8'd10;
            b = 8'd3;
            op = 2'b11;
            @(posedge start);
            #1;
            $write("Testcase 008 (Div Floor): ");
            #1;

            check_outputs(8'd3);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            @(negedge start);
            a = 8'hFF;
            b = 8'hFF;
            op = 2'b01;
            @(posedge start);
            #1;
            $write("Testcase 009 (Max Sub): ");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            @(negedge start);
            a = 8'd127;
            b = 8'd0;
            op = 2'b10;
            @(posedge start);
            #1;
            $write("Testcase 010 (Mul by Zero): ");
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_result;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, op, start, result);
    end

endmodule
