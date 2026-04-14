`timescale 1ns/1ps

module alu_32bit_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg [2:0] op_sel;
    reg rst_n;
    wire [31:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_32bit dut (
        .a(a),
        .b(b),
        .clk(clk),
        .op_sel(op_sel),
        .rst_n(rst_n),
        .result(result),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        a = 0;
        b = 0;
        op_sel = 0;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Running Testcase001: Addition (5 + 10)");
        a = 32'd5;
        b = 32'd10;
        op_sel = 3'b000;
        @(posedge clk);
        #1 #1;
 check_outputs(32'd15, 1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Running Testcase002: Subtraction (20 - 5)");
        a = 32'd20;
        b = 32'd5;
        op_sel = 3'b001;
        @(posedge clk);
        #1 #1;
 check_outputs(32'd15, 1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Running Testcase003: AND (0xF0F0 & 0xFFFF)");
        a = 32'h0000F0F0;
        b = 32'h0000FFFF;
        op_sel = 3'b010;
        @(posedge clk);
        #1 #1;
 check_outputs(32'h0000F0F0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Running Testcase004: OR (0xAAAA | 0x5555)");
        a = 32'hAAAA0000;
        b = 32'h55550000;
        op_sel = 3'b011;
        @(posedge clk);
        #1 #1;
 check_outputs(32'hFFFF0000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Running Testcase005: XOR (0x1234 ^ 0x1234)");
        a = 32'h12345678;
        b = 32'h12345678;
        op_sel = 3'b100;
        @(posedge clk);
        #1 #1;
 check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        $display("Running Testcase006: Zero Flag (Sub 100-100)");
        a = 32'd100;
        b = 32'd100;
        op_sel = 3'b001;
        @(posedge clk);
        #1 #1;
 check_outputs(32'h0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        $display("Running Testcase007: Max value addition (0xFFFFFFFF + 1)");
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        op_sel = 3'b000;
        @(posedge clk);
        #1 #1;
 check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        $display("Running Testcase008: Subtraction resulting in negative (unsigned)");
        a = 32'd0;
        b = 32'd1;
        op_sel = 3'b001;
        @(posedge clk);
        #1 #1;
 check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_32bit Testbench");
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, clk, op_sel, rst_n, result, zero);
    end

endmodule
