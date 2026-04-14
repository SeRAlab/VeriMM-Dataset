`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg cs;
    reg [7:0] din;
    reg rw;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .cs(cs),
        .din(din),
        .rw(rw),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cs = 0;
            rw = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            cs = 1; rw = 0; addr = 8'h55; din = 8'hAA;
            @(posedge clk); #1;


            cs = 1; rw = 1; addr = 8'h55;
            @(posedge clk); #1;

            $display("Testcase %0d: Basic Write/Read Address 0x55", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            cs = 1; rw = 0; addr = 8'hFF; din = 8'h12;
            @(posedge clk); #1;


            cs = 1; rw = 1; addr = 8'hFF;
            @(posedge clk); #1;

            $display("Testcase %0d: Boundary Write/Read Address 0xFF", test_num);
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            cs = 1; rw = 0; addr = 8'h00; din = 8'hE7;
            @(posedge clk); #1;


            cs = 1; rw = 1; addr = 8'h00;
            @(posedge clk); #1;

            $display("Testcase %0d: Boundary Write/Read Address 0x00", test_num);
            #1;

            check_outputs(8'hE7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            cs = 1; rw = 0; addr = 8'h10; din = 8'h66;
            @(posedge clk); #1;


            cs = 0; rw = 0; addr = 8'h10; din = 8'h99;
            @(posedge clk); #1;


            cs = 1; rw = 1; addr = 8'h10;
            @(posedge clk); #1;

            $display("Testcase %0d: Chip Select (cs) Write Disable Check", test_num);
            #1;

            check_outputs(8'h66);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            cs = 1; rw = 0; addr = 8'h20; din = 8'h11;
            @(posedge clk); #1;


            cs = 1; rw = 0; addr = 8'h20; din = 8'h22;
            @(posedge clk); #1;


            cs = 1; rw = 1; addr = 8'h20;
            @(posedge clk); #1;

            $display("Testcase %0d: Overwrite Data Check", test_num);
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            cs = 1; rw = 0; addr = 8'hA0; din = 8'hA1;
            @(posedge clk); #1;


            cs = 1; rw = 0; addr = 8'hB0; din = 8'hB1;
            @(posedge clk); #1;


            cs = 1; rw = 1; addr = 8'hA0;
            @(posedge clk); #1;

            $display("Testcase %0d: Multiple Address Integrity Check", test_num);
            #1;

            check_outputs(8'hA1);
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
        $dumpvars(0,addr, clk, cs, din, rw, dout);
    end

endmodule
