`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] accum;
    reg clk;
    reg con_alu;
    reg [7:0] data;
    reg [2:0] opcode;
    reg rst;
    wire [7:0] alu_out;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .accum(accum),
        .clk(clk),
        .con_alu(con_alu),
        .data(data),
        .opcode(opcode),
        .rst(rst),
        .alu_out(alu_out),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        accum = 0;
        data = 0;
        opcode = 0;
        con_alu = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        accum = 8'h10;
        data = 8'h05;
        opcode = 3'b010;
        con_alu = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h15, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        accum = 8'hFF;
        data = 8'hA5;
        opcode = 3'b011;
        con_alu = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'hA5, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        accum = 8'hAA;
        data = 8'h55;
        opcode = 3'b100;
        con_alu = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'hFF, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        accum = 8'h12;
        data = 8'hE7;
        opcode = 3'b101;
        con_alu = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'hE7, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        accum = 8'h00;
        data = 8'h00;
        opcode = 3'b001;
        con_alu = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        accum = 8'h01;
        data = 8'h00;
        opcode = 3'b001;
        con_alu = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h01, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        accum = 8'hCC;
        opcode = 3'b000;
        con_alu = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'hCC, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        accum = 8'h33;
        opcode = 3'b110;
        con_alu = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h33, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        accum = 8'h44;
        opcode = 3'b111;
        con_alu = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h44, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();
        accum = 8'h10;
        data = 8'h10;
        opcode = 3'b010;
        con_alu = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h10, 1'b0);
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
        input [7:0] expected_alu_out;
        input expected_zero;
        begin
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h, zero=%b",
                         alu_out, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h, zero=%b",
                         expected_alu_out, expected_zero);
                $display("  Got:      alu_out=%h, zero=%b",
                         alu_out, zero);
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
        $dumpvars(0,accum, clk, con_alu, data, opcode, rst, alu_out, zero);
    end

endmodule
