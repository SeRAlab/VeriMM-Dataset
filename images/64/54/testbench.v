`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] DRAM_W;
    reg [7:0] D_addr_R;
    reg [7:0] D_addr_W;
    reg R;
    reg W;
    reg [7:0] ddatain;
    reg gclk;
    wire [7:0] DRAM_R;
    wire [7:0] daddr;
    wire [7:0] ddataout;
    wire wea;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DRAM_W(DRAM_W),
        .D_addr_R(D_addr_R),
        .D_addr_W(D_addr_W),
        .R(R),
        .W(W),
        .ddatain(ddatain),
        .gclk(gclk),
        .DRAM_R(DRAM_R),
        .daddr(daddr),
        .ddataout(ddataout),
        .wea(wea)
    );

    // Clock generation (10ns period)
    initial begin
        gclk = 0;
        forever #5 gclk = ~gclk;
    end

        task reset_dut;

        begin
            W = 0;
            R = 0;
            D_addr_W = 0;
            D_addr_R = 0;
            DRAM_W = 0;
            ddatain = 0;
            @(posedge gclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write Operation", test_num);
            reset_dut();

            W = 1;
            D_addr_W = 8'hAA;
            DRAM_W = 8'h55;
            R = 0;


            repeat(4) @(posedge gclk);
            #1;


            #1;



            check_outputs(8'h00, 8'hAA, 8'h55, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Read Operation", test_num);
            reset_dut();

            W = 0;
            R = 1;
            D_addr_R = 8'h33;
            ddatain = 8'hBE;

            repeat(2) @(posedge gclk);
            #1;


            #1;



            check_outputs(8'hBE, 8'h33, 8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous Write and Read", test_num);
            reset_dut();

            W = 1;
            R = 1;
            D_addr_W = 8'hF0;
            D_addr_R = 8'h0F;
            DRAM_W = 8'hCC;
            ddatain = 8'h33;

            repeat(4) @(posedge gclk);
            #1;


            #1;



            check_outputs(8'h33, 8'hF0, 8'hCC, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State (No R/W)", test_num);
            reset_dut();

            W = 0;
            R = 0;
            ddatain = 8'hZZ;

            repeat(2) @(posedge gclk);
            #1;



            if (wea === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: Controller stayed idle.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: wea active during idle.");
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Write", test_num);
            reset_dut();

            W = 1;
            D_addr_W = 8'h12;
            DRAM_W = 8'h34;

            repeat(2) @(posedge gclk);
            DRAM_W = 8'h78;

            repeat(2) @(posedge gclk);
            #1;

            #1;


            check_outputs(8'h00, 8'h12, 8'h78, 1'b1);
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
        input [7:0] expected_DRAM_R;
        input [7:0] expected_daddr;
        input [7:0] expected_ddataout;
        input expected_wea;
        begin
            if (expected_DRAM_R === (expected_DRAM_R ^ DRAM_R ^ expected_DRAM_R) &&
                expected_daddr === (expected_daddr ^ daddr ^ expected_daddr) &&
                expected_ddataout === (expected_ddataout ^ ddataout ^ expected_ddataout) &&
                expected_wea === (expected_wea ^ wea ^ expected_wea)) begin
                $display("PASS");
                $display("  Outputs: DRAM_R=%h, daddr=%h, ddataout=%h, wea=%b",
                         DRAM_R, daddr, ddataout, wea);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DRAM_R=%h, daddr=%h, ddataout=%h, wea=%b",
                         expected_DRAM_R, expected_daddr, expected_ddataout, expected_wea);
                $display("  Got:      DRAM_R=%h, daddr=%h, ddataout=%h, wea=%b",
                         DRAM_R, daddr, ddataout, wea);
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
        $dumpvars(0,DRAM_W, D_addr_R, D_addr_W, R, W, ddatain, gclk, DRAM_R, daddr, ddataout, wea);
    end

endmodule
