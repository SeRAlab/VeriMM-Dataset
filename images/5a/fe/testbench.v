`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] BUS_ADD;
    reg BUS_CLK;
    reg BUS_RD;
    reg BUS_RST;
    reg BUS_WR;
    wire [7:0] BUS_DATA_OUT_1;
    wire [7:0] BUS_DATA_OUT_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BUS_ADD(BUS_ADD),
        .BUS_CLK(BUS_CLK),
        .BUS_RD(BUS_RD),
        .BUS_RST(BUS_RST),
        .BUS_WR(BUS_WR),
        .BUS_DATA_OUT_1(BUS_DATA_OUT_1),
        .BUS_DATA_OUT_2(BUS_DATA_OUT_2)
    );

    // Clock generation (10ns period)
    initial begin
        BUS_CLK = 0;
        forever #5 BUS_CLK = ~BUS_CLK;
    end

        task reset_dut;

        begin
            BUS_RST = 1;
            BUS_ADD = 16'h0000;
            BUS_RD = 0;
            BUS_WR = 0;
            bus_data_in_drive = 8'hzz;
            repeat(2) @(posedge BUS_CLK);
            #1 BUS_RST = 0;
            repeat(1) @(posedge BUS_CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write to GPIO 1 at address 0x0000", test_num);
            reset_dut();
            BUS_ADD = 16'h0000;
            bus_data_in_drive = 8'hA5;
            BUS_WR = 1;
            @(posedge BUS_CLK);
            #1;
            BUS_WR = 0;
            bus_data_in_drive = 8'hzz;
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Write to GPIO 1 at address 0x000F", test_num);
            reset_dut();
            BUS_ADD = 16'h000F;
            bus_data_in_drive = 8'h5A;
            BUS_WR = 1;
            @(posedge BUS_CLK);
            #1;
            BUS_WR = 0;
            bus_data_in_drive = 8'hzz;
            #1;

            check_outputs(8'h5A, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Write to GPIO 2 at address 0x0010", test_num);
            reset_dut();
            BUS_ADD = 16'h0010;
            bus_data_in_drive = 8'h3C;
            BUS_WR = 1;
            @(posedge BUS_CLK);
            #1;
            BUS_WR = 0;
            bus_data_in_drive = 8'hzz;
            #1;

            check_outputs(8'h00, 8'h3C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Write to GPIO 2 at address 0x001F", test_num);
            reset_dut();
            BUS_ADD = 16'h001F;
            bus_data_in_drive = 8'hC3;
            BUS_WR = 1;
            @(posedge BUS_CLK);
            #1;
            BUS_WR = 0;
            bus_data_in_drive = 8'hzz;
            #1;

            check_outputs(8'h00, 8'hC3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Write to address 0x0020 (Out of Range)", test_num);
            reset_dut();
            BUS_ADD = 16'h0020;
            bus_data_in_drive = 8'hFF;
            BUS_WR = 1;
            @(posedge BUS_CLK);
            #1;
            BUS_WR = 0;
            bus_data_in_drive = 8'hzz;

            #1;


            check_outputs(8'h00, 8'h00);
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
        input [7:0] expected_BUS_DATA_OUT_1;
        input [7:0] expected_BUS_DATA_OUT_2;
        begin
            if (expected_BUS_DATA_OUT_1 === (expected_BUS_DATA_OUT_1 ^ BUS_DATA_OUT_1 ^ expected_BUS_DATA_OUT_1) &&
                expected_BUS_DATA_OUT_2 === (expected_BUS_DATA_OUT_2 ^ BUS_DATA_OUT_2 ^ expected_BUS_DATA_OUT_2)) begin
                $display("PASS");
                $display("  Outputs: BUS_DATA_OUT_1=%h, BUS_DATA_OUT_2=%h",
                         BUS_DATA_OUT_1, BUS_DATA_OUT_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BUS_DATA_OUT_1=%h, BUS_DATA_OUT_2=%h",
                         expected_BUS_DATA_OUT_1, expected_BUS_DATA_OUT_2);
                $display("  Got:      BUS_DATA_OUT_1=%h, BUS_DATA_OUT_2=%h",
                         BUS_DATA_OUT_1, BUS_DATA_OUT_2);
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
        $dumpvars(0,BUS_ADD, BUS_CLK, BUS_RD, BUS_RST, BUS_WR, BUS_DATA_OUT_1, BUS_DATA_OUT_2);
    end

endmodule
