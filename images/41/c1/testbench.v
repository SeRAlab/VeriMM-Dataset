`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] i_addr;
    reg i_din;
    reg [7:0] i_jp1_state;
    reg [7:0] i_jp2_state;
    reg i_wr;
    reg rst;
    wire [7:0] o_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_addr(i_addr),
        .i_din(i_din),
        .i_jp1_state(i_jp1_state),
        .i_jp2_state(i_jp2_state),
        .i_wr(i_wr),
        .rst(rst),
        .o_dout(o_dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            i_wr = 0;
            i_addr = 16'h0;
            i_din = 1'b0;
            i_jp1_state = 8'h0;
            i_jp2_state = 8'h0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            i_jp1_state = 8'hA5;
            i_jp2_state = 8'h00;
            i_addr = 16'h4016;
            i_wr = 0;
            @(posedge clk);
            #2;
            $display("Testcase 001: Reading Joypad 1 at 0x4016");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            i_jp1_state = 8'h00;
            i_jp2_state = 8'h3C;
            i_addr = 16'h4017;
            i_wr = 0;
            @(posedge clk);
            #2;
            $display("Testcase 002: Reading Joypad 2 at 0x4017");
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            i_jp1_state = 8'hFF;
            i_jp2_state = 8'hFF;
            i_addr = 16'h0000;
            i_wr = 0;
            @(posedge clk);
            #2;
            $display("Testcase 003: Reading invalid address 0x0000");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            i_jp1_state = 8'h81;
            i_addr = 16'h4016;


            i_din = 1'b1;
            i_wr = 1'b1;
            @(posedge clk);


            i_din = 1'b0;
            i_wr = 1'b1;
            @(posedge clk);


            i_wr = 1'b0;
            @(posedge clk);
            #2;
            $display("Testcase 004: Write Strobe then Read Joypad 1");
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            i_addr = 16'h4016;
            i_wr = 0;


            i_jp1_state = 8'h11;
            @(posedge clk);
            #1;


            i_jp1_state = 8'hEE;
            @(posedge clk);
            #2;
            $display("Testcase 005: Verify data update on Joypad 1");
            #1;

            check_outputs(8'hEE);
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
        input [7:0] expected_o_dout;
        begin
            if (expected_o_dout === (expected_o_dout ^ o_dout ^ expected_o_dout)) begin
                $display("PASS");
                $display("  Outputs: o_dout=%h",
                         o_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_dout=%h",
                         expected_o_dout);
                $display("  Got:      o_dout=%h",
                         o_dout);
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
        $dumpvars(0,clk, i_addr, i_din, i_jp1_state, i_jp2_state, i_wr, rst, o_dout);
    end

endmodule
