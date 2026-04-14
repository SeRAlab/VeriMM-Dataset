`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk;
    reg i_rst;
    reg [11:0] mm_adr;
    reg [23:0] mm_odat;
    reg mm_we;
    wire [23:0] mm_idat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .mm_adr(mm_adr),
        .mm_odat(mm_odat),
        .mm_we(mm_we),
        .mm_idat(mm_idat)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_rst = 1;
            mm_we = 0;
            mm_adr = 0;
            mm_odat = 0;
            @(posedge i_clk);
            #1 i_rst = 0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and Read Address 0 (Expected 0)", test_num);
            reset_dut();
            mm_we = 0;
            mm_adr = 12'd0;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Check Predefined Values at Addr 64, 65, 66", test_num);
            reset_dut();


            mm_adr = 12'd64;
            mm_we = 0;
            @(posedge i_clk); #1;


            #1;



            check_outputs(24'h000040);


            mm_adr = 12'd65;
            @(posedge i_clk); #1;
            #1;

            check_outputs(24'h000041);


            mm_adr = 12'd66;
            @(posedge i_clk); #1;
            #1;

            check_outputs(24'h000042);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write to Addr 500 and Read back", test_num);
            reset_dut();


            mm_we = 1;
            mm_adr = 12'd500;
            mm_odat = 24'hABCDEF;
            @(posedge i_clk);
            #1 mm_we = 0;


            @(posedge i_clk);
            #1;
            #1;

            check_outputs(24'hABCDEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Write/Read at max address 4095", test_num);
            reset_dut();

            mm_we = 1;
            mm_adr = 12'd4095;
            mm_odat = 24'hFFFFFF;
            @(posedge i_clk);
            #1 mm_we = 0;

            @(posedge i_clk);
            #1;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Verify Reset clears data at Addr 100", test_num);
            reset_dut();


            mm_we = 1;
            mm_adr = 12'd100;
            mm_odat = 24'h123456;
            @(posedge i_clk);


            i_rst = 1;
            @(posedge i_clk);
            #1 i_rst = 0;


            mm_we = 0;
            mm_adr = 12'd100;
            @(posedge i_clk);
            #1;
            #1;

            check_outputs(24'h000000);
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
        input [23:0] expected_mm_idat;
        begin
            if (expected_mm_idat === (expected_mm_idat ^ mm_idat ^ expected_mm_idat)) begin
                $display("PASS");
                $display("  Outputs: mm_idat=%h",
                         mm_idat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mm_idat=%h",
                         expected_mm_idat);
                $display("  Got:      mm_idat=%h",
                         mm_idat);
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
        $dumpvars(0,i_clk, i_rst, mm_adr, mm_odat, mm_we, mm_idat);
    end

endmodule
