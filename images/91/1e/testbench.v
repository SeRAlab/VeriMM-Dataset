`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg ShiftEn;
    reg ShiftIn;
    reg reset;
    wire [3:0] ParallelOut;
    wire ShiftOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .ShiftEn(ShiftEn),
        .ShiftIn(ShiftIn),
        .reset(reset),
        .ParallelOut(ParallelOut),
        .ShiftOut(ShiftOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ShiftEn = 0;
            ShiftIn = 0;
            @(posedge Clk);
            #2;
            reset = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 4 bits (1011)", test_num);

            ShiftEn = 1;
            ShiftIn = 1; @(posedge Clk); #1;
            ShiftIn = 0; @(posedge Clk); #1;
            ShiftIn = 1; @(posedge Clk); #1;
            ShiftIn = 1; @(posedge Clk); #1;
            ShiftEn = 0;



            #1;




            check_outputs(4'b1011, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Shift 16 bits (100...0)", test_num);

            ShiftEn = 1;
            ShiftIn = 1; @(posedge Clk); #1;
            ShiftIn = 0;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge Clk); #1;
            end
            ShiftEn = 0;




            #1;





            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Shift Enable logic", test_num);

            ShiftEn = 1; ShiftIn = 1; @(posedge Clk); #1;
            ShiftEn = 0; ShiftIn = 0; @(posedge Clk); #1;
            ShiftEn = 1; ShiftIn = 0; @(posedge Clk); #1;
            ShiftEn = 1; ShiftIn = 1; @(posedge Clk); #1;
            ShiftEn = 0;


            #1;



            check_outputs(4'b0101, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow (17-bit shift)", test_num);

            ShiftEn = 1;
            ShiftIn = 1; @(posedge Clk); #1;
            ShiftIn = 0;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge Clk); #1;
            end

            ShiftIn = 0; @(posedge Clk); #1;
            ShiftEn = 0;


            #1;



            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset mid-operation", test_num);

            ShiftEn = 1;
            ShiftIn = 1; @(posedge Clk); #1;
            ShiftIn = 1; @(posedge Clk); #1;

            reset = 1; @(posedge Clk); #1;
            reset = 0;

            #1;


            check_outputs(4'b0000, 1'b0);
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
        input [3:0] expected_ParallelOut;
        input expected_ShiftOut;
        begin
            if (expected_ParallelOut === (expected_ParallelOut ^ ParallelOut ^ expected_ParallelOut) &&
                expected_ShiftOut === (expected_ShiftOut ^ ShiftOut ^ expected_ShiftOut)) begin
                $display("PASS");
                $display("  Outputs: ParallelOut=%h, ShiftOut=%b",
                         ParallelOut, ShiftOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ParallelOut=%h, ShiftOut=%b",
                         expected_ParallelOut, expected_ShiftOut);
                $display("  Got:      ParallelOut=%h, ShiftOut=%b",
                         ParallelOut, ShiftOut);
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
        $dumpvars(0,Clk, ShiftEn, ShiftIn, reset, ParallelOut, ShiftOut);
    end

endmodule
