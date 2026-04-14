`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [7:0] Datain1;
    reg [7:0] Datain2;
    reg [7:0] Datain3;
    reg [7:0] Datain4;
    reg Reset;
    reg enable;
    reg enable1;
    wire [7:0] Dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Datain1(Datain1),
        .Datain2(Datain2),
        .Datain3(Datain3),
        .Datain4(Datain4),
        .Reset(Reset),
        .enable(enable),
        .enable1(enable1),
        .Dataout(Dataout)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 0;
            Datain1 = 0;
            Datain2 = 0;
            Datain3 = 0;
            Datain4 = 0;
            enable = 0;
            enable1 = 0;
            @(posedge Clk);
            #1;
            Reset = 1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            enable = 1;
            Datain1 = 8'h10;
            Datain2 = 8'h20;
            Datain3 = 8'h05;
            Datain4 = 8'h05;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            enable = 0;
            Datain1 = 8'h10;
            Datain2 = 8'h20;
            Datain3 = 8'h0A;
            Datain4 = 8'h0F;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(8'h19);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            enable = 1;
            Datain1 = 8'hFF;
            Datain2 = 8'h01;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            enable = 0;
            Datain3 = 8'h80;
            Datain4 = 8'h81;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            enable = 1;
            Datain1 = 8'h00;
            Datain2 = 8'h00;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin

            Reset = 1;
            enable = 1;
            Datain1 = 8'hAA;
            Datain2 = 8'h55;
            @(posedge Clk);
            #1;


            Reset = 0;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;


            enable = 1;
            Datain1 = 8'h05;
            Datain2 = 8'h05;
            Datain3 = 8'hAA;
            Datain4 = 8'hAA;
            @(posedge Clk);
            #2;


            enable = 0;
            @(posedge Clk);
            #2;
            #1;

            check_outputs(8'h54);
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
        input [7:0] expected_Dataout;
        begin
            if (expected_Dataout === (expected_Dataout ^ Dataout ^ expected_Dataout)) begin
                $display("PASS");
                $display("  Outputs: Dataout=%h",
                         Dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dataout=%h",
                         expected_Dataout);
                $display("  Got:      Dataout=%h",
                         Dataout);
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
        $dumpvars(0,Clk, Datain1, Datain2, Datain3, Datain4, Reset, enable, enable1, Dataout);
    end

endmodule
