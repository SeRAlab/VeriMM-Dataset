`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg crct;
    reg [127:0] data_core;
    reg [127:0] data_mode;
    reg en;
    reg [31:0] pdi;
    reg wr;
    wire [127:0] key;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .crct(crct),
        .data_core(data_core),
        .data_mode(data_mode),
        .en(en),
        .pdi(pdi),
        .wr(wr),
        .key(key)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            crct = 0;
            en = 0;
            wr = 0;
            pdi = 32'h0;
            data_core = 128'h0;
            data_mode = 128'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Serial Writing (4 shifts)");

            wr = 1;
            pdi = 32'hAAAA_AAAA; @(posedge clk); #1;
            pdi = 32'hBBBB_BBBB; @(posedge clk); #1;
            pdi = 32'hCCCC_CCCC; @(posedge clk); #1;
            pdi = 32'hDDDD_DDDD; @(posedge clk); #1;

            wr = 0;
            #1;

            check_outputs(128'hAAAA_AAAA_BBBB_BBBB_CCCC_CCCC_DDDD_DDDD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Load from data_core (en)");

            data_core = 128'h12345678_9ABCDEF0_0FEDCBA9_87654321;
            en = 1;
            @(posedge clk); #1;

            en = 0;
            #1;

            check_outputs(128'h12345678_9ABCDEF0_0FEDCBA9_87654321);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Load from data_mode (crct)");

            data_mode = 128'hFFFF_FFFF_0000_0000_AAAA_5555_CCCC_3333;
            crct = 1;
            @(posedge clk); #1;

            crct = 0;
            #1;

            check_outputs(128'hFFFF_FFFF_0000_0000_AAAA_5555_CCCC_3333);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Buffer Overflow (Discarding oldest)");

            wr = 1;
            pdi = 32'h1111_1111; @(posedge clk); #1;
            pdi = 32'h2222_2222; @(posedge clk); #1;
            pdi = 32'h3333_3333; @(posedge clk); #1;
            pdi = 32'h4444_4444; @(posedge clk); #1;
            pdi = 32'h5555_5555; @(posedge clk); #1;

            wr = 0;
            #1;

            check_outputs(128'h2222_2222_3333_3333_4444_4444_5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Priority Check (crct > en > wr)");

            data_mode = 128'hMODE_MODE_MODE_MODE_MODE_MODE_MODE_MODE;
            data_core = 128'hCORE_CORE_CORE_CORE_CORE_CORE_CORE_CORE;
            pdi = 32'h9999_9999;

            crct = 1;
            en = 1;
            wr = 1;
            @(posedge clk); #1;

            crct = 0; en = 0; wr = 0;

            #1;


            check_outputs(128'hMODE_MODE_MODE_MODE_MODE_MODE_MODE_MODE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case 006: Mixed Load and Shift");


            data_core = 128'h0000_0000_1111_1111_2222_2222_3333_3333;
            en = 1;
            @(posedge clk); #1;
            en = 0;


            wr = 1;
            pdi = 32'h4444_4444; @(posedge clk); #1;
            pdi = 32'h5555_5555; @(posedge clk); #1;
            wr = 0;


            #1;



            check_outputs(128'h2222_2222_3333_3333_4444_4444_5555_5555);
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
        input [127:0] expected_key;
        begin
            if (expected_key === (expected_key ^ key ^ expected_key)) begin
                $display("PASS");
                $display("  Outputs: key=%h",
                         key);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key=%h",
                         expected_key);
                $display("  Got:      key=%h",
                         key);
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
        $dumpvars(0,clk, crct, data_core, data_mode, en, pdi, wr, key);
    end

endmodule
