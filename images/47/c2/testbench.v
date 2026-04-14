`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] accum;
    reg clk;
    reg [7:0] data;
    reg [2:0] opcode;
    reg reset;
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
        .data(data),
        .opcode(opcode),
        .reset(reset),
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
            reset = 1;
            accum = 8'h00;
            data = 8'h00;
            opcode = 3'b000;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            accum = 8'hA5;
            opcode = 3'b000;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hA5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            accum = 8'h10;
            data = 8'h25;
            opcode = 3'b001;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h35, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            accum = 8'h50;
            data = 8'h10;
            opcode = 3'b010;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h40, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            accum = 8'hF0;
            data = 8'hCC;
            opcode = 3'b011;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hC0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            accum = 8'hAA;
            data = 8'h55;
            opcode = 3'b100;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            accum = 8'h01;
            opcode = 3'b101;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            accum = 8'h12;
            data = 8'hEF;
            opcode = 3'b110;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hEF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            accum = 8'h00;
            opcode = 3'b000;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            accum = 8'hFF;
            opcode = 3'b000;
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00, 1'b0);
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
        $dumpvars(0,accum, clk, data, opcode, reset, alu_out, zero);
    end

endmodule
