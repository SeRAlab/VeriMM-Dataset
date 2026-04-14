`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Addr;
    reg [7:0] AxisDQ_1;
    reg [7:0] AxisDQ_2;
    reg [7:0] AxisDQ_3;
    reg [7:0] AxisDQ_4;
    reg [7:0] AxisDQ_5;
    reg [7:0] AxisDQ_6;
    reg [7:0] AxisDQ_7;
    reg [7:0] AxisDQ_8;
    reg [15:0] CS;
    reg RD;
    reg [7:0] Xin;
    wire [7:0] DQ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr(Addr),
        .AxisDQ_1(AxisDQ_1),
        .AxisDQ_2(AxisDQ_2),
        .AxisDQ_3(AxisDQ_3),
        .AxisDQ_4(AxisDQ_4),
        .AxisDQ_5(AxisDQ_5),
        .AxisDQ_6(AxisDQ_6),
        .AxisDQ_7(AxisDQ_7),
        .AxisDQ_8(AxisDQ_8),
        .CS(CS),
        .RD(RD),
        .Xin(Xin),
        .DQ(DQ)
    );

    // Clock generation (10ns period)
    initial begin
        RD = 0;
        forever #5 RD = ~RD;
    end

        task reset_dut;

    begin
        Addr = 8'h0;
        CS = 16'h0001;
        Xin = 8'h0;
        AxisDQ_1 = 8'h0;
        AxisDQ_2 = 8'h0;
        AxisDQ_3 = 8'h0;
        AxisDQ_4 = 8'h0;
        AxisDQ_5 = 8'h0;
        AxisDQ_6 = 8'h0;
        AxisDQ_7 = 8'h0;
        AxisDQ_8 = 8'h0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Xin routing (Addr=0x10)");
        Addr = 8'h10;
        Xin = 8'hA5;
        @(negedge RD);
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Xin routing (Addr=0x1F)");
        Addr = 8'h1F;
        Xin = 8'h5A;
        @(negedge RD);
        #2;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: AxisDQ_1 routing");
        Addr = 8'h01;
        AxisDQ_1 = 8'h11;
        @(negedge RD);
        #2;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: AxisDQ_2 routing");
        Addr = 8'h02;
        AxisDQ_2 = 8'h22;
        @(negedge RD);
        #2;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: AxisDQ_3 routing");
        Addr = 8'h03;
        AxisDQ_3 = 8'h33;
        @(negedge RD);
        #2;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase 006: AxisDQ_4 routing");
        Addr = 8'h04;
        AxisDQ_4 = 8'h44;
        @(negedge RD);
        #2;
        #1;

        check_outputs(8'h44);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase 007: AxisDQ_5 routing");
        Addr = 8'h05;
        AxisDQ_5 = 8'h55;
        @(negedge RD);
        #2;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Testcase 008: AxisDQ_6 routing");
        Addr = 8'h06;
        AxisDQ_6 = 8'h66;
        @(negedge RD);
        #2;
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        $display("Testcase 009: AxisDQ_7 routing");
        Addr = 8'h07;
        AxisDQ_7 = 8'h77;
        @(negedge RD);
        #2;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = 10;
        $display("Testcase 010: AxisDQ_8 routing");
        Addr = 8'h08;
        AxisDQ_8 = 8'h88;
        @(negedge RD);
        #2;
        #1;

        check_outputs(8'h88);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_DQ;
        begin
            if (expected_DQ === (expected_DQ ^ DQ ^ expected_DQ)) begin
                $display("PASS");
                $display("  Outputs: DQ=%h",
                         DQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DQ=%h",
                         expected_DQ);
                $display("  Got:      DQ=%h",
                         DQ);
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
        $dumpvars(0,Addr, AxisDQ_1, AxisDQ_2, AxisDQ_3, AxisDQ_4, AxisDQ_5, AxisDQ_6, AxisDQ_7, AxisDQ_8, CS, RD, Xin, DQ);
    end

endmodule
