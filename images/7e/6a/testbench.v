`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
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

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ie = 0;
            de = 0;
            iaddr = 0;
            daddr = 0;
            drw = 2'b00;
            din = 0;
            switches = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset and Switch Initialization");
            switches = 8'hA5;
            reset_dut();


            ie = 1;
            de = 1;
            daddr = 32'h0;
            drw = 2'b01;

            @(posedge clk);
            #1 #1;
 check_outputs(32'h000000A5, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Data Memory Write and Read");
            reset_dut();


            de = 1;
            daddr = 32'h00000010;
            din = 32'hDEADBEEF;
            drw = 2'b10;
            @(posedge clk);


            drw = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hDEADBEEF, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Instruction Fetch Check");
            reset_dut();

            ie = 1;
            iaddr = 32'h00000FFF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Data Output Enable Control");
            reset_dut();


            de = 1;
            daddr = 32'h20;
            din = 32'h12345678;
            drw = 2'b10;
            @(posedge clk);


            de = 0;
            drw = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Multiple Writes and Address Selection");
            reset_dut();


            de = 1;
            daddr = 32'hA0;
            din = 32'hAAAA_AAAA;
            drw = 2'b10;
            @(posedge clk);


            daddr = 32'hB0;
            din = 32'hBBBB_BBBB;
            drw = 2'b10;
            @(posedge clk);


            daddr = 32'hA0;
            drw = 2'b01;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hAAAA_AAAA, 32'h00000000);
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
        input [31:0] expected_dout;
        input [31:0] expected_iout;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, daddr, de, din, drw, iaddr, ie, rst, switches, dout, iout);
    end

endmodule
