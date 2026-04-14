`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] addr;
    reg [3:0] cru_base;
    reg ti_cru_clk;
    reg ti_cru_out;
    reg ti_memen;
    reg ti_ph3;
    wire [3:0] bits;
    wire ti_cru_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .cru_base(cru_base),
        .ti_cru_clk(ti_cru_clk),
        .ti_cru_out(ti_cru_out),
        .ti_memen(ti_memen),
        .ti_ph3(ti_ph3),
        .bits(bits),
        .ti_cru_in(ti_cru_in)
    );

    // Clock generation (10ns period)
    initial begin
        ti_cru_clk = 0;
        forever #5 ti_cru_clk = ~ti_cru_clk;
    end

        task reset_dut;

        begin
            addr = 15'd0;
            cru_base = 4'd0;
            ti_cru_out = 0;
            ti_memen = 0;
            ti_ph3 = 1;
            #20;
        end
        endtask
    task write_bit;

        input [1:0] idx;
        input val;
        begin
            addr[13] = idx[1];
            addr[14] = idx[0];
            ti_cru_out = val;
            @(posedge ti_cru_clk);
            #2;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase001: Basic Write Operation...");
            cru_base = 4'b1010;




            addr = 15'b000_1010_0000_00_0; addr[3]=1; addr[4]=0; addr[5]=1; addr[6]=0;
            addr[13]=0; addr[14]=0; ti_cru_out = 1; @(posedge ti_cru_clk); #2;

            addr[13]=0; addr[14]=1; ti_cru_out = 0; @(posedge ti_cru_clk); #2;

            addr[13]=1; addr[14]=0; ti_cru_out = 1; @(posedge ti_cru_clk); #2;

            addr[13]=1; addr[14]=1; ti_cru_out = 0; @(posedge ti_cru_clk); #2;

            #10;
            #1;

            check_outputs(4'b1010, ti_cru_in);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase002: Read Bit 0 (High)...");
            cru_base = 4'b0101;

            addr[3]=0; addr[4]=1; addr[5]=0; addr[6]=1;
            addr[13]=0; addr[14]=0; ti_cru_out = 1; @(posedge ti_cru_clk); #2;


            ti_memen = 1;
            ti_ph3 = 1;
            #10;
            ti_ph3 = 0;
            #5;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase003: Read Bit 1 (Low)...");
            cru_base = 4'b0111;

            addr[3]=0; addr[4]=1; addr[5]=1; addr[6]=1;
            addr[13]=0; addr[14]=0; ti_cru_out = 1; @(posedge ti_cru_clk); #2;
            addr[13]=0; addr[14]=1; ti_cru_out = 0; @(posedge ti_cru_clk); #2;


            addr[13]=0; addr[14]=1;
            ti_memen = 1;
            ti_ph3 = 1; #10;
            ti_ph3 = 0; #5;
            #1;

            check_outputs(4'b1000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase004: Memory Enable Control...");
            cru_base = 4'b1111;

            addr[3]=1; addr[4]=1; addr[5]=1; addr[6]=1;
            addr[13]=1; addr[14]=0; ti_cru_out = 1; @(posedge ti_cru_clk); #2;


            ti_memen = 0;
            ti_ph3 = 1; #10;
            ti_ph3 = 0; #5;


            if (ti_cru_in === 1'b1)
                $display("FAIL: ti_cru_in driven while ti_memen is low");

            #1;


            check_outputs(4'b0010, ti_cru_in);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase005: Full Register Update (1111)...");
            cru_base = 4'b0000;
            addr = 0;

            write_bit(0, 1);
            write_bit(1, 1);
            write_bit(2, 1);
            write_bit(3, 1);

            #10;
            #1;

            check_outputs(4'b1111, ti_cru_in);
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
        input [3:0] expected_bits;
        input expected_ti_cru_in;
        begin
            if (expected_bits === (expected_bits ^ bits ^ expected_bits) &&
                expected_ti_cru_in === (expected_ti_cru_in ^ ti_cru_in ^ expected_ti_cru_in)) begin
                $display("PASS");
                $display("  Outputs: bits=%h, ti_cru_in=%b",
                         bits, ti_cru_in);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bits=%h, ti_cru_in=%b",
                         expected_bits, expected_ti_cru_in);
                $display("  Got:      bits=%h, ti_cru_in=%b",
                         bits, ti_cru_in);
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
        $dumpvars(0,addr, cru_base, ti_cru_clk, ti_cru_out, ti_memen, ti_ph3, bits, ti_cru_in);
    end

endmodule
