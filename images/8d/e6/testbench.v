`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] iv_addr;
    reg [1:0] iv_clk;
    reg [15:0] iv_wdata;
    reg [1:0] iv_wen;
    wire [15:0] ov_rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iv_addr(iv_addr),
        .iv_clk(iv_clk),
        .iv_wdata(iv_wdata),
        .iv_wen(iv_wen),
        .ov_rdata(ov_rdata)
    );

    // Clock generation (10ns period)
    initial begin
        iv_clk = 0;
        forever #5 iv_clk = ~iv_clk;
    end

        task reset_dut;

        begin
            iv_addr = 16'h0000;
            iv_wdata = 16'h0000;
            iv_wen = 2'b00;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read Bank A (Address 0x000A)", test_num);


            @(negedge iv_clk[0]);
            iv_wen = 2'b01;
            iv_addr = 16'h000A;
            iv_wdata = 16'hA1A1;


            @(negedge iv_clk[0]);
            iv_wen = 2'b00;


            @(posedge iv_clk[0]);
            #2;
            #1;

            check_outputs(16'hA1A1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read Bank B (Address 0x000B)", test_num);


            @(negedge iv_clk[1]);
            iv_wen = 2'b10;
            iv_addr = 16'h000B;
            iv_wdata = 16'hB2B2;


            @(negedge iv_clk[1]);
            iv_wen = 2'b00;


            @(posedge iv_clk[1]);
            #2;
            #1;

            check_outputs(16'hB2B2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Bank Separation Check (Shared Index 0x0055)", test_num);


            @(negedge iv_clk[0]);
            iv_wen = 2'b01; iv_addr = 16'h0055; iv_wdata = 16'h1111;
            @(negedge iv_clk[0]);


            iv_wen = 2'b10; iv_addr = 16'h0055; iv_wdata = 16'h2222;
            @(negedge iv_clk[0]);



            iv_wen = 2'b01;
            iv_addr = 16'h0055;
            @(posedge iv_clk[0]);
            #2;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Upper Boundary Address Check (0x00FF)", test_num);

            @(negedge iv_clk[0]);
            iv_wen = 2'b01; iv_addr = 16'h00FF; iv_wdata = 16'hFFFF;
            @(negedge iv_clk[0]);
            iv_wen = 2'b00;
            @(posedge iv_clk[0]);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Data Persistence Check", test_num);


            @(negedge iv_clk[0]);
            iv_wen = 2'b01; iv_addr = 16'h0010; iv_wdata = 16'hCAFE;
            @(negedge iv_clk[0]);


            iv_wen = 2'b01; iv_addr = 16'h0011; iv_wdata = 16'hBABE;
            @(negedge iv_clk[0]);


            iv_wen = 2'b00; iv_addr = 16'h0010;
            @(posedge iv_clk[0]);
            #2;
            #1;

            check_outputs(16'hCAFE);
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
        input [15:0] expected_ov_rdata;
        begin
            if (expected_ov_rdata === (expected_ov_rdata ^ ov_rdata ^ expected_ov_rdata)) begin
                $display("PASS");
                $display("  Outputs: ov_rdata=%h",
                         ov_rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ov_rdata=%h",
                         expected_ov_rdata);
                $display("  Got:      ov_rdata=%h",
                         ov_rdata);
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
        $dumpvars(0,iv_addr, iv_clk, iv_wdata, iv_wen, ov_rdata);
    end

endmodule
