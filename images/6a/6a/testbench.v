`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg clk;
    reg [7:0] din;
    reg iorq_n;
    reg rd_n;
    reg rst_n;
    reg wr_n;
    wire [7:0] addr;
    wire [7:0] dout;
    wire oe_n;
    wire read_from_reg;
    wire regaddr_changed;
    wire write_to_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .din(din),
        .iorq_n(iorq_n),
        .rd_n(rd_n),
        .rst_n(rst_n),
        .wr_n(wr_n),
        .addr(addr),
        .dout(dout),
        .oe_n(oe_n),
        .read_from_reg(read_from_reg),
        .regaddr_changed(regaddr_changed),
        .write_to_reg(write_to_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 16'h0;
            din = 8'h0;
            iorq_n = 1;
            rd_n = 1;
            wr_n = 1;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            #1;


            check_outputs(8'h00, 8'h00, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            @(posedge clk);
            a = 16'hC000;
            din = 8'hA5;
            iorq_n = 0;
            wr_n = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 8'h00, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            @(posedge clk);
            a = 16'hC000; din = 8'h5A; iorq_n = 0; wr_n = 0;
            @(posedge clk);

            wr_n = 1;
            rd_n = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h5A, 8'h5A, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            @(posedge clk);
            a = 16'h8000;
            iorq_n = 0;
            wr_n = 0;
            #1;

            #1;


            check_outputs(8'h00, 8'h00, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            @(posedge clk);
            a = 16'h8000;
            iorq_n = 0;
            rd_n = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h00, 1'b0, 1'b1, 1'b0, 1'b0);
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
        input [7:0] expected_addr;
        input [7:0] expected_dout;
        input expected_oe_n;
        input expected_read_from_reg;
        input expected_regaddr_changed;
        input expected_write_to_reg;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_oe_n === (expected_oe_n ^ oe_n ^ expected_oe_n) &&
                expected_read_from_reg === (expected_read_from_reg ^ read_from_reg ^ expected_read_from_reg) &&
                expected_regaddr_changed === (expected_regaddr_changed ^ regaddr_changed ^ expected_regaddr_changed) &&
                expected_write_to_reg === (expected_write_to_reg ^ write_to_reg ^ expected_write_to_reg)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, dout=%h, oe_n=%b, read_from_reg=%b, regaddr_changed=%b, write_to_reg=%b",
                         addr, dout, oe_n, read_from_reg, regaddr_changed, write_to_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, dout=%h, oe_n=%b, read_from_reg=%b, regaddr_changed=%b, write_to_reg=%b",
                         expected_addr, expected_dout, expected_oe_n, expected_read_from_reg, expected_regaddr_changed, expected_write_to_reg);
                $display("  Got:      addr=%h, dout=%h, oe_n=%b, read_from_reg=%b, regaddr_changed=%b, write_to_reg=%b",
                         addr, dout, oe_n, read_from_reg, regaddr_changed, write_to_reg);
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
        $dumpvars(0,a, clk, din, iorq_n, rd_n, rst_n, wr_n, addr, dout, oe_n, read_from_reg, regaddr_changed, write_to_reg);
    end

endmodule
