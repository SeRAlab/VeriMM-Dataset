`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] d;
    reg reset_l;
    reg [8:0] t_addr;
    reg [8:0] t_wa;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset_l(reset_l),
        .t_addr(t_addr),
        .t_wa(t_wa),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_l = 0;
            d = 64'h0;
            t_wa = 9'h0;
            t_addr = 9'h0;
            repeat(2) @(posedge clk);
            #1;
            reset_l = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write/Read Address 0", test_num);
            reset_dut();


            t_wa = 9'h000;
            d = 64'hAAAA_BBBB_CCCC_DDDD;
            @(posedge clk);
            #1;


            t_addr = 9'h000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hAAAA_BBBB_CCCC_DDDD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write/Read Max Address (511)", test_num);
            reset_dut();


            t_wa = 9'h1FF;
            d = 64'h1234_5678_9ABC_DEF0;
            @(posedge clk);
            #1;


            t_addr = 9'h1FF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h1234_5678_9ABC_DEF0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address Isolation Check", test_num);
            reset_dut();


            t_wa = 9'h010;
            d = 64'h5555_5555_5555_5555;
            @(posedge clk);


            t_wa = 9'h020;
            d = 64'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            #1;


            t_addr = 9'h010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h5555_5555_5555_5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Overwrite", test_num);
            reset_dut();


            t_wa = 9'h0A0;
            d = 64'h1;
            @(posedge clk);


            t_wa = 9'h0A0;
            d = 64'hDEAD_BEEF;
            @(posedge clk);
            #1;


            t_addr = 9'h0A0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'hDEAD_BEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Address Decoding (Bit 8 Walk)", test_num);
            reset_dut();


            t_wa = 9'h100;
            d = 64'h8888_7777_6666_5555;
            @(posedge clk);


            t_wa = 9'h000;
            d = 64'h1111_2222_3333_4444;
            @(posedge clk);
            #1;


            t_addr = 9'h100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(64'h8888_7777_6666_5555);
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
        input [63:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, d, reset_l, t_addr, t_wa, out);
    end

endmodule
