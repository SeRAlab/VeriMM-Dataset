`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IRQin;
    reg [2:0] PCSrc;
    reg [31:0] PCplusin;
    reg branch;
    reg clk;
    reg datahazard;
    reg [31:0] instructionin;
    wire IRQout;
    wire [31:0] PCplusout;
    wire [31:0] instructionout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IRQin(IRQin),
        .PCSrc(PCSrc),
        .PCplusin(PCplusin),
        .branch(branch),
        .clk(clk),
        .datahazard(datahazard),
        .instructionin(instructionin),
        .IRQout(IRQout),
        .PCplusout(PCplusout),
        .instructionout(instructionout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            IRQin = 0;
            PCSrc = 3'b000;
            PCplusin = 32'h0;
            branch = 0;
            datahazard = 0;
            instructionin = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            instructionin = 32'hDEADBEEF;
            PCplusin = 32'h00001004;
            datahazard = 0;
            PCSrc = 3'b000;
            branch = 0;
            IRQin = 0;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Normal Operation", test_num);
            #1;

            check_outputs(1'b0, 32'h00001004, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            instructionin = 32'hAAAA1111;
            PCplusin = 32'h00000010;
            @(posedge clk);
            #1;


            datahazard = 1;
            instructionin = 32'hBBBB2222;
            PCplusin = 32'h00000020;
            @(posedge clk);
            #2;

            $display("Testcase %0d: Data Hazard (Stall)", test_num);

            #1;


            check_outputs(1'b0, 32'h00000010, 32'hAAAA1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            instructionin = 32'hC0DE0001;
            PCplusin = 32'h00000040;
            branch = 1;

            @(posedge clk);
            #2;

            $display("Testcase %0d: Branch Flush", test_num);


            #1;



            check_outputs(1'b0, 32'h00000040, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            instructionin = 32'h12345678;
            PCplusin = 32'h000000A0;
            @(posedge clk);
            #1;


            datahazard = 1;
            PCSrc = 3'b001;
            instructionin = 32'h87654321;
            PCplusin = 32'h000000B0;

            @(posedge clk);
            #2;

            $display("Testcase %0d: PCSrc Hazard Override", test_num);


            #1;



            check_outputs(1'b0, 32'h000000B0, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            IRQin = 1;
            #1;

            $display("Testcase %0d: IRQ Direct Pass-through", test_num);
            #1;

            check_outputs(1'b1, 32'h00000000, 32'h00000000);

            IRQin = 0;
            #1;
            #1;

            check_outputs(1'b0, 32'h00000000, 32'h00000000);
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
        input expected_IRQout;
        input [31:0] expected_PCplusout;
        input [31:0] expected_instructionout;
        begin
            if (expected_IRQout === (expected_IRQout ^ IRQout ^ expected_IRQout) &&
                expected_PCplusout === (expected_PCplusout ^ PCplusout ^ expected_PCplusout) &&
                expected_instructionout === (expected_instructionout ^ instructionout ^ expected_instructionout)) begin
                $display("PASS");
                $display("  Outputs: IRQout=%b, PCplusout=%h, instructionout=%h",
                         IRQout, PCplusout, instructionout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IRQout=%b, PCplusout=%h, instructionout=%h",
                         expected_IRQout, expected_PCplusout, expected_instructionout);
                $display("  Got:      IRQout=%b, PCplusout=%h, instructionout=%h",
                         IRQout, PCplusout, instructionout);
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
        $dumpvars(0,IRQin, PCSrc, PCplusin, branch, clk, datahazard, instructionin, IRQout, PCplusout, instructionout);
    end

endmodule
