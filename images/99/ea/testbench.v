`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg alu_op;
    reg clk;
    reg [7:0] i0;
    reg [7:0] i1;
    wire [7:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_op(alu_op),
        .clk(clk),
        .i0(i0),
        .i1(i1),
        .o(o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(posedge clk);
        alu_op <= 0;
        i0 <= 0;
        i1 <= 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test %0d: Addition (5 + 10)", test_num);
        alu_op <= 1'b0;
        i0 <= 8'd5;
        i1 <= 8'd10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test %0d: Addition with Overflow (255 + 1)", test_num);
        alu_op <= 1'b0;
        i0 <= 8'hFF;
        i1 <= 8'h01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test %0d: Addition with Max Values (255 + 255)", test_num);
        alu_op <= 1'b0;
        i0 <= 8'hFF;
        i1 <= 8'hFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test %0d: Left Shift (1 << 1)", test_num);
        alu_op <= 1'b1;
        i0 <= 8'h01;
        i1 <= 8'h01;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test %0d: Left Shift (0x0F << 4)", test_num);
        alu_op <= 1'b1;
        i0 <= 8'h0F;
        i1 <= 8'h04;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Test %0d: Left Shift (0xFF << 8)", test_num);
        alu_op <= 1'b1;
        i0 <= 8'hFF;
        i1 <= 8'd8;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Test %0d: Left Shift (0xAA << 0)", test_num);
        alu_op <= 1'b1;
        i0 <= 8'hAA;
        i1 <= 8'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Test %0d: Switch Op (Add then Shift)", test_num);

        alu_op <= 1'b0; i0 <= 8'd10; i1 <= 8'd10;
        @(posedge clk);
        #1;

        alu_op <= 1'b1; i0 <= 8'h01; i1 <= 8'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h04);
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
        input [7:0] expected_o;
        begin
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
        $dumpvars(0,alu_op, clk, i0, i1, o);
    end

endmodule
