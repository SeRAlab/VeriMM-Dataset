`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [2:0] op;
    reg [4:0] reg_addr;
    reg reg_write;
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
        .reg_addr(reg_addr),
        .reg_write(reg_write),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        reg_write = 0;
        forever #5 reg_write = ~reg_write;
    end

        task reset_dut;

        begin
            a = 8'h0;
            b = 8'h0;
            op = 3'h0;
            reg_addr = 5'h0;
            wait_cycle();
        end
        endtask
    task wait_cycle;

        begin
            @(posedge reg_write);
            #2;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 8'd15;
            b = 8'd25;
            op = 3'b000;
            reg_addr = 5'd1;
            wait_cycle();
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 8'd100;
            b = 8'd40;
            op = 3'b001;
            reg_addr = 5'd2;
            wait_cycle();
            #1;

            check_outputs(8'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 8'b10101010;
            b = 8'b11110000;
            op = 3'b010;
            reg_addr = 5'd3;
            wait_cycle();
            #1;

            check_outputs(8'b10100000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 8'b10101010;
            b = 8'b01010101;
            op = 3'b011;
            reg_addr = 5'd4;
            wait_cycle();
            #1;

            check_outputs(8'b11111111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 8'hFF;
            b = 8'hAA;
            op = 3'b100;
            reg_addr = 5'd5;
            wait_cycle();
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 8'd10;
            b = 8'd20;
            op = 3'b001;
            reg_addr = 5'd6;
            wait_cycle();
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 8'd200;
            b = 8'd100;
            op = 3'b000;
            reg_addr = 5'd7;
            wait_cycle();
            #1;

            check_outputs(8'd44);
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
        $dumpvars(0,a, b, op, reg_addr, reg_write, result);
    end

endmodule
