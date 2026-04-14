`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [3:0] ParallelIn;
    reg ShiftEn;
    reg ShiftIn;
    reg load;
    wire [3:0] RegContent;
    wire ShiftOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .ParallelIn(ParallelIn),
        .ShiftEn(ShiftEn),
        .ShiftIn(ShiftIn),
        .load(load),
        .RegContent(RegContent),
        .ShiftOut(ShiftOut)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            load = 1;
            ParallelIn = 4'b0000;
            ShiftEn = 0;
            ShiftIn = 0;
            @(posedge Clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Data 4'b1010", test_num);
            reset_dut();

            load = 1;
            ParallelIn = 4'b1010;
            @(posedge Clk);
            #1;
            load = 0;


            #1;



            check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 4'b0001 then Shift Left with ShiftIn=1", test_num);
            reset_dut();


            load = 1;
            ParallelIn = 4'b0001;
            @(posedge Clk);
            #1;


            load = 0;
            ShiftEn = 1;
            ShiftIn = 1;
            @(posedge Clk);
            #1;


            #1;



            check_outputs(4'b0011, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential shifts to fill register", test_num);
            reset_dut();

            load = 0;
            ShiftEn = 1;
            ShiftIn = 1;
            @(posedge Clk);
            #1;
            @(posedge Clk);
            #1;
            @(posedge Clk);
            #1;
            @(posedge Clk);
            #1;


            #1;



            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load priority check (Load=1, ShiftEn=1)", test_num);
            reset_dut();


            load = 1;
            ShiftEn = 1;
            ParallelIn = 4'b0110;
            ShiftIn = 1;

            @(posedge Clk);
            #1;


            #1;



            check_outputs(4'b0110, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold state check (ShiftEn=0, Load=0)", test_num);
            reset_dut();


            load = 1;
            ParallelIn = 4'b1100;
            @(posedge Clk);
            #1;


            load = 0;
            ShiftEn = 0;
            ShiftIn = 1;
            @(posedge Clk);
            #1;


            #1;



            check_outputs(4'b1100, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift-through logic check", test_num);
            reset_dut();


            load = 1;
            ParallelIn = 4'b1000;
            @(posedge Clk);
            #1;


            load = 0;
            ShiftEn = 1;
            ShiftIn = 0;
            @(posedge Clk);
            #1;


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
        input [3:0] expected_RegContent;
        input expected_ShiftOut;
        begin
            if (expected_RegContent === (expected_RegContent ^ RegContent ^ expected_RegContent) &&
                expected_ShiftOut === (expected_ShiftOut ^ ShiftOut ^ expected_ShiftOut)) begin
                $display("PASS");
                $display("  Outputs: RegContent=%h, ShiftOut=%b",
                         RegContent, ShiftOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegContent=%h, ShiftOut=%b",
                         expected_RegContent, expected_ShiftOut);
                $display("  Got:      RegContent=%h, ShiftOut=%b",
                         RegContent, ShiftOut);
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
        $dumpvars(0,Clk, ParallelIn, ShiftEn, ShiftIn, load, RegContent, ShiftOut);
    end

endmodule
