`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] DataIn;
    reg [2:0] Raddr;
    reg [2:0] Waddr;
    reg WriteEn;
    wire [7:0] DataOutA;
    wire [7:0] DataOutB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .DataIn(DataIn),
        .Raddr(Raddr),
        .Waddr(Waddr),
        .WriteEn(WriteEn),
        .DataOutA(DataOutA),
        .DataOutB(DataOutB)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        integer i;
        begin
            WriteEn = 0;
            Raddr = 0;
            Waddr = 0;
            DataIn = 0;

            @(negedge Clk);
            for (i = 0; i < 8; i = i + 1) begin
                WriteEn = 1;
                Waddr = i;
                DataIn = 8'h00;
                @(negedge Clk);
            end
            WriteEn = 0;
            Waddr = 0;
            DataIn = 0;
            @(negedge Clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Write/Read Reg0");
            reset_dut();
            @(negedge Clk);
            WriteEn = 1;
            Waddr = 3'd0;
            DataIn = 8'hAA;
            @(negedge Clk);
            WriteEn = 0;
            Raddr = 3'd0;
            #1;
            #1;

            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Multi-register check");
            reset_dut();
            @(negedge Clk);

            WriteEn = 1; Waddr = 3'd0; DataIn = 8'h11;
            @(negedge Clk);

            WriteEn = 1; Waddr = 3'd5; DataIn = 8'h55;
            @(negedge Clk);
            WriteEn = 0;
            Raddr = 3'd5;
            #1;
            #1;

            check_outputs(8'h11, 8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Write Enable logic check");
            reset_dut();
            @(negedge Clk);

            WriteEn = 1; Waddr = 3'd2; DataIn = 8'hCC;
            @(negedge Clk);

            WriteEn = 0; Waddr = 3'd2; DataIn = 8'hFF;
            @(negedge Clk);
            Raddr = 3'd2;
            #1;
            #1;

            check_outputs(8'h00, 8'hCC);
        end
        endtask

    task testcase004;

        integer j;
        begin
            $display("\nRunning testcase004: Exhaustive write sequence");
            reset_dut();
            @(negedge Clk);
            for (j = 0; j < 8; j = j + 1) begin
                WriteEn = 1;
                Waddr = j;
                DataIn = j + 8'h10;
                @(negedge Clk);
            end
            WriteEn = 0;
            Raddr = 3'd7;
            #1;
            #1;

            check_outputs(8'h10, 8'h17);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Overwrite check");
            reset_dut();
            @(negedge Clk);
            WriteEn = 1; Waddr = 3'd4; DataIn = 8'hDE;
            @(negedge Clk);
            WriteEn = 1; Waddr = 3'd4; DataIn = 8'hAD;
            @(negedge Clk);
            WriteEn = 0;
            Raddr = 3'd4;
            #1;
            #1;

            check_outputs(8'h00, 8'hAD);
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
        input [7:0] expected_DataOutA;
        input [7:0] expected_DataOutB;
        begin
            if (expected_DataOutA === (expected_DataOutA ^ DataOutA ^ expected_DataOutA) &&
                expected_DataOutB === (expected_DataOutB ^ DataOutB ^ expected_DataOutB)) begin
                $display("PASS");
                $display("  Outputs: DataOutA=%h, DataOutB=%h",
                         DataOutA, DataOutB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOutA=%h, DataOutB=%h",
                         expected_DataOutA, expected_DataOutB);
                $display("  Got:      DataOutA=%h, DataOutB=%h",
                         DataOutA, DataOutB);
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
        $dumpvars(0,Clk, DataIn, Raddr, Waddr, WriteEn, DataOutA, DataOutB);
    end

endmodule
