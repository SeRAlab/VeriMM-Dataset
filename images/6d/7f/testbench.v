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
            ie = 0;
            de = 0;
            iaddr = 32'h0;
            daddr = 32'h0;
            drw = 2'b00;
            din = 32'h0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'hzzzzzzzz, 32'hzzzzzzzz, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write Operation (0x3C)", test_num);
            reset_dut();

            de = 1;
            drw = 2'b01;
            daddr = 32'h0000_0000;
            din = 32'hFFFF_FF3C;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hzzzzzzzz, 32'hzzzzzzzz, 8'h3C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read Back Verification", test_num);
            reset_dut();


            de = 1;
            drw = 2'b01;
            din = 32'h0000_00A5;
            @(posedge clk);


            drw = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_00A5, 32'hzzzzzzzz, 8'hA5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: dout High Impedance Check", test_num);
            reset_dut();

            de = 0;
            drw = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hzzzzzzzz, 32'hzzzzzzzz, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: iout High Impedance Check", test_num);
            reset_dut();

            ie = 0;
            iaddr = 32'h1234_5678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hzzzzzzzz, 32'hzzzzzzzz, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Write Operations", test_num);
            reset_dut();

            de = 1;
            drw = 2'b01;

            din = 32'h11;
            @(posedge clk);

            din = 32'h22;
            @(posedge clk);

            din = 32'h44;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hzzzzzzzz, 32'hzzzzzzzz, 8'h44);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-operation Reset Check", test_num);
            reset_dut();

            de = 1;
            drw = 2'b01;
            din = 32'h00;
            @(posedge clk);
            #1;

            if (leds != 8'h00) $display("Intermediate write failed");

            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hzzzzzzzz, 32'hzzzzzzzz, 8'hFF);
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
