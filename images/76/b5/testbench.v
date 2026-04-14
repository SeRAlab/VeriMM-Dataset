`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ClrW;
    reg [31:0] Delay;
    reg [11:0] Depth;
    reg H_L;
    reg [11:0] PerCnt;
    reg RE;
    reg Start;
    reg Wclk;
    reg nRclk;
    wire Empty;
    wire Full;
    wire Ready;
    wire [11:0] Rptr;
    wire Sampled;
    wire [11:0] Wptr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ClrW(ClrW),
        .Delay(Delay),
        .Depth(Depth),
        .H_L(H_L),
        .PerCnt(PerCnt),
        .RE(RE),
        .Start(Start),
        .Wclk(Wclk),
        .nRclk(nRclk),
        .Empty(Empty),
        .Full(Full),
        .Ready(Ready),
        .Rptr(Rptr),
        .Sampled(Sampled),
        .Wptr(Wptr)
    );

    // Clock generation (10ns period)
    initial begin
        ClrW = 0;
        forever #5 ClrW = ~ClrW;
    end

        task reset_dut;

        begin
            Start = 0;
            RE = 0;
            H_L = 0;
            Depth = 12'd16;
            PerCnt = 12'd1;
            Delay = 32'd0;
            Wclk = 0;
            nRclk = 1;


            repeat(5) @(posedge ClrW);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 12'h0, 1'b0, 12'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            Start = 1;
            Depth = 12'd16;
            @(posedge ClrW);
            #1;
            Wclk = 1;
            #10;
            Wclk = 0;
            #10;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 12'h0, 1'b0, 12'h1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            Start = 1;
            Depth = 12'd8;
            @(posedge ClrW);
            #1;
            for (i = 0; i < 8; i = i + 1) begin
                Wclk = 1; #10; Wclk = 0; #10;
            end

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 12'h0, 1'b0, 12'h8);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            Start = 1;
            Depth = 12'd16;

            for (i = 0; i < 4; i = i + 1) begin
                Wclk = 1; #10; Wclk = 0; #10;
            end

            RE = 1;
            for (i = 0; i < 4; i = i + 1) begin
                nRclk = 0; #10; nRclk = 1; #10;
            end

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 12'h4, 1'b0, 12'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            Start = 1;
            Wclk = 1; #10; Wclk = 0; #10;

            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 12'h0, 1'b0, 12'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            Start = 1;
            Depth = 12'd16;
            PerCnt = 12'd1;
            @(posedge ClrW);
            #1;
            Wclk = 1; #10; Wclk = 0; #10;


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 12'h0, 1'b1, 12'h1);
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
        input expected_Empty;
        input expected_Full;
        input expected_Ready;
        input [11:0] expected_Rptr;
        input expected_Sampled;
        input [11:0] expected_Wptr;
        begin
            if (expected_Empty === (expected_Empty ^ Empty ^ expected_Empty) &&
                expected_Full === (expected_Full ^ Full ^ expected_Full) &&
                expected_Ready === (expected_Ready ^ Ready ^ expected_Ready) &&
                expected_Rptr === (expected_Rptr ^ Rptr ^ expected_Rptr) &&
                expected_Sampled === (expected_Sampled ^ Sampled ^ expected_Sampled) &&
                expected_Wptr === (expected_Wptr ^ Wptr ^ expected_Wptr)) begin
                $display("PASS");
                $display("  Outputs: Empty=%b, Full=%b, Ready=%b, Rptr=%h, Sampled=%b, Wptr=%h",
                         Empty, Full, Ready, Rptr, Sampled, Wptr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Empty=%b, Full=%b, Ready=%b, Rptr=%h, Sampled=%b, Wptr=%h",
                         expected_Empty, expected_Full, expected_Ready, expected_Rptr, expected_Sampled, expected_Wptr);
                $display("  Got:      Empty=%b, Full=%b, Ready=%b, Rptr=%h, Sampled=%b, Wptr=%h",
                         Empty, Full, Ready, Rptr, Sampled, Wptr);
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
        $dumpvars(0,ClrW, Delay, Depth, H_L, PerCnt, RE, Start, Wclk, nRclk, Empty, Full, Ready, Rptr, Sampled, Wptr);
    end

endmodule
