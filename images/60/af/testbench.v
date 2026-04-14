`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BUS_CLK;
    reg BUS_RD;
    reg BUS_RST;
    reg BUS_WR;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BUS_CLK(BUS_CLK),
        .BUS_RD(BUS_RD),
        .BUS_RST(BUS_RST),
        .BUS_WR(BUS_WR),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        BUS_CLK = 0;
        forever #5 BUS_CLK = ~BUS_CLK;
    end

        task reset_dut;

        begin
            BUS_RST = 1;
            BUS_RD = 0;
            BUS_WR = 0;
            BUS_ADD_DRV = 32'bz;
            BUS_DATA_DRV = 32'bz;
            repeat(2) @(posedge BUS_CLK);
            #1;
            BUS_RST = 0;
            @(posedge BUS_CLK);
            #1;
        end
        endtask
    task bus_write;

        input [31:0] addr;
        input [31:0] data;
        begin
            @(posedge BUS_CLK);
            #1;
            BUS_WR = 1;
            BUS_ADD_DRV = addr;
            BUS_DATA_DRV = data;
            @(posedge BUS_CLK);
            #1;

            @(posedge BUS_CLK);
            #1;
            BUS_WR = 0;
            BUS_ADD_DRV = 32'bz;
            BUS_DATA_DRV = 32'bz;
            @(posedge BUS_CLK);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single write to address 0x1000", test_num);
            reset_dut();
            bus_write(32'h00001000, 32'hDEADBEEF);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multiple writes to address 0x1000", test_num);
            reset_dut();
            bus_write(32'h00001000, 32'h1);
            bus_write(32'h00001000, 32'h2);
            bus_write(32'h00001000, 32'h3);
            #1;

            check_outputs(32'h00000003);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Write to invalid address (0x2000)", test_num);
            reset_dut();
            bus_write(32'h00002000, 32'hAAAA);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Mixed valid and invalid writes", test_num);
            reset_dut();
            bus_write(32'h00001000, 32'h1);
            bus_write(32'h00001001, 32'h2);
            bus_write(32'h00001000, 32'h3);
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Read operation check", test_num);
            reset_dut();
            @(posedge BUS_CLK);
            #1;
            BUS_RD = 1;
            BUS_ADD_DRV = 32'h00001000;
            repeat(2) @(posedge BUS_CLK);
            #1;
            BUS_RD = 0;
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,BUS_CLK, BUS_RD, BUS_RST, BUS_WR, count);
    end

endmodule
