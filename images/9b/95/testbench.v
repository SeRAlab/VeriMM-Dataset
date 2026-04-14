`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [10:0] A;
    reg CLK;
    reg [7:0] DIN;
    reg EN;
    reg WE;
    wire [7:0] DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .CLK(CLK),
        .DIN(DIN),
        .EN(EN),
        .WE(WE),
        .DOUT(DOUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            A = 0;
            DIN = 0;
            EN = 0;
            WE = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Initial State Check", test_num);


            A = 11'h000;
            EN = 1;
            WE = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read", test_num);


            A = 11'h123;
            DIN = 8'hA5;
            EN = 1;
            WE = 1;
            @(posedge CLK);
            #1;


            WE = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Multi-address independence", test_num);


            A = 11'h005; DIN = 8'h11; EN = 1; WE = 1; @(posedge CLK);
            A = 11'h006; DIN = 8'h22; EN = 1; WE = 1; @(posedge CLK);
            #1;


            A = 11'h005; WE = 0; @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Enable signal (EN=0) during write", test_num);


            A = 11'h010;
            DIN = 8'hFF;
            EN = 0;
            WE = 1;
            @(posedge CLK);
            #1;


            EN = 1;
            WE = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Enable signal (EN=0) during read", test_num);


            A = 11'h001; DIN = 8'hCC; EN = 1; WE = 1; @(posedge CLK);
            #1;

            WE = 0; @(posedge CLK);
            #1;


            A = 11'h002;
            EN = 0;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(8'hCC);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Overwriting data", test_num);


            A = 11'h7FF; DIN = 8'h10; EN = 1; WE = 1; @(posedge CLK);
            #1;

            DIN = 8'h20; @(posedge CLK);
            #1;

            WE = 0; @(posedge CLK);
            #1;

            #1;


            check_outputs(8'h20);
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
        input [7:0] expected_DOUT;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h",
                         expected_DOUT);
                $display("  Got:      DOUT=%h",
                         DOUT);
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
        $dumpvars(0,A, CLK, DIN, EN, WE, DOUT);
    end

endmodule
