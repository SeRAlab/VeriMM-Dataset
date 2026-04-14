`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] RW0_addr;
    reg RW0_clk;
    reg RW0_en;
    reg [63:0] RW0_wdata;
    reg RW0_wmode;
    wire [63:0] RW0_rdata;

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
            RW0_en = 0;
            RW0_wmode = 0;
            RW0_addr = 0;
            RW0_wdata = 0;
            repeat(2) @(posedge RW0_clk);
        end
        endtask
    task write_cycle;

        input [8:0] addr;
        input [63:0] data;
        begin
            @(posedge RW0_clk);
            RW0_en = 1;
            RW0_wmode = 1;
            RW0_addr = addr;
            RW0_wdata = data;
            @(posedge RW0_clk);
            RW0_en = 0;
            RW0_wmode = 0;
        end
        endtask

    task read_cycle;

        input [8:0] addr;
        begin
            @(posedge RW0_clk);
            RW0_en = 1;
            RW0_wmode = 0;
            RW0_addr = addr;
            @(posedge RW0_clk);

            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write/Read Address 0", test_num);
            reset_dut();
            write_cycle(9'h000, 64'hFEEDFACECAFEBEEF);
            read_cycle(9'h000);
            #1;

            check_outputs(64'hFEEDFACECAFEBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Address Boundary Check (511)", test_num);
            reset_dut();
            write_cycle(9'h1FF, 64'hAAAA_BBBB_CCCC_DDDD);
            read_cycle(9'h1FF);
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Check", test_num);
            reset_dut();
            write_cycle(9'h0A5, 64'h1111_1111_1111_1111);
            write_cycle(9'h0A5, 64'h2222_2222_2222_2222);
            read_cycle(9'h0A5);
            #1;

            check_outputs(64'h2222_2222_2222_2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable Inhibition Check", test_num);
            reset_dut();

            write_cycle(9'h010, 64'h5555_AAAA_5555_AAAA);


            @(posedge RW0_clk);
            RW0_en = 0;
            RW0_wmode = 1;
            RW0_addr = 9'h010;
            RW0_wdata = 64'h0000_0000_0000_0000;
            @(posedge RW0_clk);


            read_cycle(9'h010);
            #1;

            check_outputs(64'h5555_AAAA_5555_AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Write/Read Multiple Addresses", test_num);
            reset_dut();
            write_cycle(9'h001, 64'h1);
            write_cycle(9'h002, 64'h2);
            write_cycle(9'h003, 64'h3);

            read_cycle(9'h001);
            read_cycle(9'h003);
            #1;

            check_outputs(64'h0000_0000_0000_0003);
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
        input [63:0] expected_RW0_rdata;
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
        $dumpvars(0,RW0_addr, RW0_clk, RW0_en, RW0_wdata, RW0_wmode, RW0_rdata);
    end

endmodule
