`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg direction;
    reg enable;
    reg rst_n;
    reg [7:0] wdata;
    wire [7:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .direction(direction),
        .enable(enable),
        .rst_n(rst_n),
        .wdata(wdata),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            addr = 0;
            direction = 0;
            enable = 0;
            wdata = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase 001: Initial Reset Verification");
            reset_dut();

            enable = 1;
            direction = 0;


            addr = ADDR_DATA;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase 002: Data Register Write/Read");
            reset_dut();


            enable = 1;
            direction = 1;
            addr = ADDR_DATA;
            wdata = 8'hA5;
            @(posedge clk);


            #1 direction = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase 003: Control Register Write/Read");
            reset_dut();


            enable = 1;
            direction = 1;
            addr = ADDR_CTRL;
            wdata = 8'h5A;
            @(posedge clk);


            #1 direction = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase 004: Status Register Write/Read");
            reset_dut();


            enable = 1;
            direction = 1;
            addr = ADDR_STAT;
            wdata = 8'hFF;
            @(posedge clk);


            #1 direction = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase 005: Enable Signal Verification");
            reset_dut();


            enable = 0;
            direction = 1;
            addr = ADDR_DATA;
            wdata = 8'h12;
            @(posedge clk);


            #1 enable = 1;
            direction = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase 006: Multiple Sequential Operations");
            reset_dut();

            enable = 1;
            direction = 1;


            addr = ADDR_CTRL; wdata = 8'h01; @(posedge clk);

            #1 addr = ADDR_DATA; wdata = 8'h02; @(posedge clk);

            #1 addr = ADDR_STAT; wdata = 8'h03; @(posedge clk);


            #1 direction = 0;
            addr = ADDR_DATA;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase 007: Unmapped Address Read");
            reset_dut();

            enable = 1;
            direction = 0;
            addr = 32'hFFFF_FFFF;
            @(posedge clk); #1;


            #1;



            check_outputs(8'h00);
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
        testcase007();
        
        
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
        input [7:0] expected_rdata;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
        $dumpvars(0,addr, clk, direction, enable, rst_n, wdata, rdata);
    end

endmodule
