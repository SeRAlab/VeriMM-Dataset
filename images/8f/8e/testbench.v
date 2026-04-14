`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg [2:0] op;
    wire [7:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .op(op),
        .res(res)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 0;
            b <= 0;
            op <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Addition (15 + 25)", test_num);
            a <= 8'd15;
            b <= 8'd25;
            op <= 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Addition Overflow (250 + 10)", test_num);
            a <= 8'd250;
            b <= 8'd10;
            op <= 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Subtraction (50 - 20)", test_num);
            a <= 8'd50;
            b <= 8'd20;
            op <= 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Subtraction Negative (10 - 20)", test_num);
            a <= 8'd10;
            b <= 8'd20;
            op <= 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Bitwise AND (0xAA & 0xF0)", test_num);
            a <= 8'hAA;
            b <= 8'hF0;
            op <= 3'b010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Bitwise OR (0x0F | 0xF0)", test_num);
            a <= 8'h0F;
            b <= 8'hF0;
            op <= 3'b011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %03d: Bitwise XOR (0x55 ^ 0xAA)", test_num);
            a <= 8'h55;
            b <= 8'hAA;
            op <= 3'b100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %03d: Bitwise NAND (0x0F ~& 0xFF)", test_num);
            a <= 8'h0F;
            b <= 8'hFF;
            op <= 3'b101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %03d: Bitwise NOR (0x01 ~| 0x02)", test_num);
            a <= 8'h01;
            b <= 8'h02;
            op <= 3'b110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFC);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Testcase %03d: Bitwise XNOR (0xAA ~^ 0xAA)", test_num);
            a <= 8'hAA;
            b <= 8'hAA;
            op <= 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_res;
        begin
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
        $dumpvars(0,a, b, clk, op, res);
    end

endmodule
