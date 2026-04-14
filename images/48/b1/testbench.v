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
    wire [31:0] dout;
    wire [31:0] iout;
    wire [7:0] leds;

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
        .dout(dout),
        .iout(iout),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            de = 0;
            drw = 2'b00;
            din = 32'h0;
            iaddr = 32'h0;
            daddr = 32'h0;
            ie = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power-on Reset", test_num);
            reset_dut();


            #1;



            check_outputs(32'h000000FF, 32'h00000000, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Write 0x55", test_num);
            reset_dut();

            de = 1;
            drw = 2'b01;
            din = 32'h00000055;
            iaddr = 32'h00001000;

            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h00000055, 32'h00001000, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write Enable Gating", test_num);
            reset_dut();


            de = 1; drw = 2'b01; din = 32'h000000AA;
            @(negedge clk); #2;


            de = 0; din = 32'h000000BB;
            @(negedge clk); #2;


            #1;



            check_outputs(32'h000000AA, 32'h00000000, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Control Bits (drw) Gating", test_num);
            reset_dut();


            de = 1; drw = 2'b01; din = 32'h00000012;
            @(negedge clk); #2;


            de = 1; drw = 2'b00; din = 32'h00000034;
            @(negedge clk); #2;


            #1;



            check_outputs(32'h00000012, 32'h00000000, 8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Capture Lower 8 Bits Only", test_num);
            reset_dut();

            de = 1;
            drw = 2'b01;
            din = 32'hDEADBE66;
            iaddr = 32'hFFFFFFFF;

            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h00000066, 32'hFFFFFFFF, 8'h66);
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
        input [7:0] expected_leds;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_iout === (expected_iout ^ iout ^ expected_iout) &&
                expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, iout=%h, leds=%h",
                         dout, iout, leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, iout=%h, leds=%h",
                         expected_dout, expected_iout, expected_leds);
                $display("  Got:      dout=%h, iout=%h, leds=%h",
                         dout, iout, leds);
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
        $dumpvars(0,clk, daddr, de, din, drw, iaddr, ie, rst, dout, iout, leds);
    end

endmodule
