`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [31:0] daddr;
    reg de;
    reg [31:0] din;
    reg [1:0] drw;
    reg [31:0] iaddr;
    reg ie;
    reg rst;
    reg [7:0] switches;
    wire [31:0] dout;
    wire [31:0] iout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .daddr(daddr),
        .de(de),
        .din(din),
        .drw(drw),
        .iaddr(iaddr),
        .ie(ie),
        .rst(rst),
        .switches(switches),
        .dout(dout),
        .iout(iout)
    );
    task testcase001;

        begin
            $display("Testcase 001: Resetting the module...");
            rst = 1;
            clk = 0;
            de = 0;
            ie = 0;
            daddr = 32'h0;
            iaddr = 32'h0;
            din = 32'h0;
            drw = 2'b00;
            switches = 8'hFF;

            #10 clk = 1; #10 clk = 0;
            rst = 0;
            #10 clk = 1; #10 clk = 0;


            #1;



            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Reading switches (Value: 0x55)...");
            rst = 0;
            de = 1;
            drw = 2'b00;
            daddr = 32'h0;
            switches = 8'h55;

            #10 clk = 1; #10 clk = 0;


            #1;



            check_outputs(32'h00000055, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Reading switches (Value: 0xAA)...");
            rst = 0;
            de = 1;
            drw = 2'b00;
            daddr = 32'h4;
            switches = 8'hAA;

            #10 clk = 1; #10 clk = 0;

            #1;


            check_outputs(32'h000000AA, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Reading with de=0 (Output should be 0)...");
            rst = 0;
            de = 0;
            drw = 2'b00;
            switches = 8'hFF;

            #10 clk = 1; #10 clk = 0;


            #1;



            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Testing IE and full switch value...");
            rst = 0;
            de = 1;
            ie = 1;
            iaddr = 32'h100;
            drw = 2'b00;
            switches = 8'hFF;

            #10 clk = 1; #10 clk = 0;


            #1;



            check_outputs(32'h000000FF, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Attempting to write to switches (should be ignored)...");
            rst = 0;
            de = 1;
            drw = 2'b01;
            din = 32'hDEADBEEF;
            switches = 8'h12;

            #10 clk = 1; #10 clk = 0;


            #1;



            check_outputs(32'h00000012, 32'h0);
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
        input [31:0] expected_dout;
        input [31:0] expected_iout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_iout === (expected_iout ^ iout ^ expected_iout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, iout=%h",
                         dout, iout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, iout=%h",
                         expected_dout, expected_iout);
                $display("  Got:      dout=%h, iout=%h",
                         dout, iout);
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

endmodule
