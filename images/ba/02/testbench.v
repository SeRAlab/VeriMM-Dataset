`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] alu_op;
    reg clk;
    reg [2:0] m_in;
    reg [2:0] r_in1;
    reg [2:0] r_in2;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_op(alu_op),
        .clk(clk),
        .m_in(m_in),
        .r_in1(r_in1),
        .r_in2(r_in2),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        alu_op = 7'b0;
        r_in1 = 3'b0;
        r_in2 = 3'b0;
        m_in = 3'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: ALU Zero Operation", test_num);
        alu_op = 7'd0;
        r_in1 = 3'b111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: ALU NOT Operation", test_num);
        alu_op = 7'd1;
        r_in1 = 3'b101;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: ALU Right Shift Operation", test_num);
        alu_op = 7'd2;
        r_in1 = 3'b110;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: ALU Rotate Operation", test_num);
        alu_op = 7'd3;
        r_in1 = 3'b001;
        @(posedge clk);
        #1;

        #1;


        check_outputs(3'b100);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: ALU Add Operation", test_num);
        alu_op = 7'd4;
        r_in1 = 3'd2;
        r_in2 = 3'd3;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: ALU Add Overflow Operation", test_num);
        alu_op = 7'd4;
        r_in1 = 3'd7;
        r_in2 = 3'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: ALU Pass-through r_in1", test_num);
        alu_op = 7'd5;
        r_in1 = 3'b110;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: ALU Pass-through m_in", test_num);
        alu_op = 7'd6;
        m_in = 3'b011;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b011);
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
        input [2:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,alu_op, clk, m_in, r_in1, r_in2, out);
    end

endmodule
