`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] RW0_addr;
    reg RW0_clk;
    reg RW0_en;
    reg [79:0] RW0_wdata;
    reg [3:0] RW0_wmask;
    reg RW0_wmode;
    wire [79:0] RW0_rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RW0_addr(RW0_addr),
        .RW0_clk(RW0_clk),
        .RW0_en(RW0_en),
        .RW0_wdata(RW0_wdata),
        .RW0_wmask(RW0_wmask),
        .RW0_wmode(RW0_wmode),
        .RW0_rdata(RW0_rdata)
    );

    // Clock generation (10ns period)
    initial begin
        RW0_clk = 0;
        forever #5 RW0_clk = ~RW0_clk;
    end

        task reset_dut;

        begin
            RW0_addr = 0;
            RW0_en = 0;
            RW0_wmode = 0;
            RW0_wmask = 0;
            RW0_wdata = 0;
            repeat(2) @(posedge RW0_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write/Read...");
            reset_dut();
            write_mem(6'h0A, 80'hFEDCBA98765432100123, 4'hF);
            read_mem(6'h0A);
            #1;

            check_outputs(80'hFEDCBA98765432100123);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Masked Write...");
            reset_dut();

            write_mem(6'h15, 80'h0, 4'hF);

            write_mem(6'h15, 80'hAAAAABBBBBCCCCCDDDDD, 4'b1010);
            read_mem(6'h15);

            #1;


            check_outputs(80'hAAAAA00000CCCCC00000);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Enable Signal Check...");
            reset_dut();

            write_mem(6'h20, 80'h11111111111111111111, 4'hF);

            @(negedge RW0_clk);
            RW0_addr = 6'h20;
            RW0_wdata = 80'hEEEEEEEEEEEEEEEEEEEE;
            RW0_wmode = 1;
            RW0_en = 0;
            @(posedge RW0_clk);
            #1;

            read_mem(6'h20);
            #1;

            check_outputs(80'h11111111111111111111);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Address Independence...");
            reset_dut();
            write_mem(6'h01, 80'hAAAAAAAAAAAAAAAAAAAA, 4'hF);
            write_mem(6'h3F, 80'h55555555555555555555, 4'hF);
            read_mem(6'h01);
            #1;

            check_outputs(80'hAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwrite check...");
            reset_dut();
            write_mem(6'h30, 80'h12345123451234512345, 4'hF);
            write_mem(6'h30, 80'hABCDEABCDEABCDEABCDE, 4'hF);
            read_mem(6'h30);
            #1;

            check_outputs(80'hABCDEABCDEABCDEABCDE);
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
        input [79:0] expected_RW0_rdata;
        begin
            if (expected_RW0_rdata === (expected_RW0_rdata ^ RW0_rdata ^ expected_RW0_rdata)) begin
                $display("PASS");
                $display("  Outputs: RW0_rdata=%h",
                         RW0_rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RW0_rdata=%h",
                         expected_RW0_rdata);
                $display("  Got:      RW0_rdata=%h",
                         RW0_rdata);
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
        $dumpvars(0,RW0_addr, RW0_clk, RW0_en, RW0_wdata, RW0_wmask, RW0_wmode, RW0_rdata);
    end

endmodule
