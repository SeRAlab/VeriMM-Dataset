`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg [4:0] DA;
    reg [31:0] Data;
    reg [31:0] F;
    reg [1:0] MD;
    reg RESET;
    reg RW;
    reg VxorN;
    wire [31:0] BUS_D;
    wire [4:0] DA_out;
    wire RW_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .DA(DA),
        .Data(Data),
        .F(F),
        .MD(MD),
        .RESET(RESET),
        .RW(RW),
        .VxorN(VxorN),
        .BUS_D(BUS_D),
        .DA_out(DA_out),
        .RW_out(RW_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            RESET = 1;
            RW = 0;
            DA = 0;
            MD = 0;
            VxorN = 0;
            F = 0;
            Data = 0;
            @(negedge CLOCK);
            RESET = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            RW = 1;
            DA = 5'h0A;
            MD = 2'b00;
            F = 32'hDEADBEEF;
            Data = 32'h11112222;
            VxorN = 0;
            @(negedge CLOCK);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 5'h0A, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            RW = 0;
            DA = 5'h1F;
            MD = 2'b01;
            F = 32'hAAAAAAAA;
            Data = 32'h55555555;
            VxorN = 1;
            @(negedge CLOCK);
            #1;
            #1;

            check_outputs(32'h55555555, 5'h1F, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            RW = 1;
            DA = 5'h00;
            MD = 2'b10;
            VxorN = 1;
            F = 32'h0;
            Data = 32'h0;
            @(negedge CLOCK);
            #1;
            #1;

            check_outputs(32'h00000001, 5'h00, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            RW = 1;
            DA = 5'h10;
            MD = 2'b10;
            VxorN = 0;
            @(negedge CLOCK);
            #1;
            #1;

            check_outputs(32'h00000000, 5'h10, 1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            RW = 0;
            DA = 5'b11111;
            MD = 2'b00;
            F = 32'hFFFFFFFF;
            @(negedge CLOCK);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 5'b11111, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            RW = 1; DA = 5'h05; MD = 2'b01; Data = 32'h12345678;
            @(negedge CLOCK);
            #1;

            RW = 0; DA = 5'h12; MD = 2'b00; F = 32'h87654321;
            @(negedge CLOCK);
            #1;
            #1;

            check_outputs(32'h87654321, 5'h12, 0);
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
        input [31:0] expected_BUS_D;
        input [4:0] expected_DA_out;
        input expected_RW_out;
        begin
            if (expected_BUS_D === (expected_BUS_D ^ BUS_D ^ expected_BUS_D) &&
                expected_DA_out === (expected_DA_out ^ DA_out ^ expected_DA_out) &&
                expected_RW_out === (expected_RW_out ^ RW_out ^ expected_RW_out)) begin
                $display("PASS");
                $display("  Outputs: BUS_D=%h, DA_out=%h, RW_out=%b",
                         BUS_D, DA_out, RW_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BUS_D=%h, DA_out=%h, RW_out=%b",
                         expected_BUS_D, expected_DA_out, expected_RW_out);
                $display("  Got:      BUS_D=%h, DA_out=%h, RW_out=%b",
                         BUS_D, DA_out, RW_out);
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
        $dumpvars(0,CLOCK, DA, Data, F, MD, RESET, RW, VxorN, BUS_D, DA_out, RW_out);
    end

endmodule
