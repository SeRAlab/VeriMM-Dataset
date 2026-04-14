`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] addr;
    reg clk;
    reg [7:0] din;
    reg rd;
    reg wr;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .rd(rd),
        .wr(wr),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr = 0;
            rd = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Write and Read", test_num);
            reset_dut();


            wr = 1;
            addr = 64'h05;
            din = 8'hAA;
            @(posedge clk);
            #1;
            wr = 0;


            rd = 1;
            addr = 64'h05;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
            rd = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Multiple Addresses Verification", test_num);
            reset_dut();


            wr = 1; addr = 64'h10; din = 8'h55;
            @(posedge clk); #1;


            wr = 1; addr = 64'h20; din = 8'h33;
            @(posedge clk); #1;
            wr = 0;


            rd = 1; addr = 64'h10;
            @(posedge clk); #1;
            if (dout !== 8'h55) begin
                #1;

                check_outputs(8'h55);
            end else begin

                rd = 1; addr = 64'h20;
                @(posedge clk); #1;
                #1;

                check_outputs(8'h33);
            end
            rd = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Overwrite Data", test_num);
            reset_dut();


            wr = 1; addr = 64'h0F; din = 8'h11;
            @(posedge clk); #1;


            wr = 1; addr = 64'h0F; din = 8'hFF;
            @(posedge clk); #1;
            wr = 0;


            rd = 1; addr = 64'h0F;
            @(posedge clk); #1;
            #1;

            check_outputs(8'hFF);
            rd = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Write Enable (wr=0) Check", test_num);
            reset_dut();


            wr = 1; addr = 64'hA0; din = 8'hBC;
            @(posedge clk); #1;


            wr = 0; addr = 64'hA0; din = 8'hEE;
            @(posedge clk); #1;


            rd = 1; addr = 64'hA0;
            @(posedge clk); #1;
            #1;

            check_outputs(8'hBC);
            rd = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: High Address Verification", test_num);
            reset_dut();



            wr = 1; addr = 64'd63; din = 8'h99;
            @(posedge clk); #1;
            wr = 0;

            rd = 1; addr = 64'd63;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h99);
            rd = 0;
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
        input [7:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addr, clk, din, rd, wr, dout);
    end

endmodule
