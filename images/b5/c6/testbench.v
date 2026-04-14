`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] addr;
    reg clk;
    reg [9:0] din;
    reg rd_en;
    reg we;
    wire [9:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .rd_en(rd_en),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            rd_en = 0;
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


            we = 1;
            addr = 11'h000;
            din = 10'h1A5;
            @(posedge clk);
            #1;
            we = 0;


            rd_en = 1;
            addr = 11'h000;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Basic Write/Read Address 0", test_num);
            #1;

            check_outputs(10'h1A5);
            rd_en = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            we = 1;
            addr = 11'd2047;
            din = 10'h3FF;
            @(posedge clk);
            #1;
            we = 0;


            rd_en = 1;
            addr = 11'd2047;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Max Address Boundary Test (2047)", test_num);
            #1;

            check_outputs(10'h3FF);
            rd_en = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            we = 1; addr = 11'd10; din = 10'h0AA;
            @(posedge clk); #1;

            we = 1; addr = 11'd20; din = 10'h255;
            @(posedge clk); #1;
            we = 0;


            rd_en = 1; addr = 11'd10;
            @(posedge clk); #1;
            @(posedge clk); #1;

            $display("Testcase %0d: Verifying Address 10 after multiple writes", test_num);
            #1;

            check_outputs(10'h0AA);
            rd_en = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            we = 1; addr = 11'd500; din = 10'h111;
            @(posedge clk); #1;

            we = 1; addr = 11'd500; din = 10'h222;
            @(posedge clk); #1;
            we = 0;


            rd_en = 1; addr = 11'd500;
            @(posedge clk); #1;
            @(posedge clk); #1;

            $display("Testcase %0d: Overwrite check at Address 500", test_num);
            #1;

            check_outputs(10'h222);
            rd_en = 0;
        end
        endtask

    task testcase005;

        reg [9:0] first_val;
        begin
            test_num = 5;
            reset_dut();


            we = 1; addr = 11'd100; din = 10'h2BC;
            @(posedge clk); #1;
            we = 0;


            rd_en = 1; addr = 11'd100;
            @(posedge clk); #1;
            @(posedge clk); #1;
            first_val = dout;


            we = 1; addr = 11'd100; din = 10'h000;
            @(posedge clk); #1;
            we = 0;

            rd_en = 0; addr = 11'd100;
            @(posedge clk); #1;
            @(posedge clk); #1;

            $display("Testcase %0d: Read Enable check (data should not update to 000)", test_num);


            #1;



            check_outputs(first_val);
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
        input [9:0] expected_dout;
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
        $dumpvars(0,addr, clk, din, rd_en, we, dout);
    end

endmodule
