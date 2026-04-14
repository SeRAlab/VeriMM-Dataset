`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA1;
    reg [7:0] DATA2;
    reg LDCOMP;
    reg LDPRE;
    reg RST;
    reg SEL;
    wire [7:0] DATA0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA1(DATA1),
        .DATA2(DATA2),
        .LDCOMP(LDCOMP),
        .LDPRE(LDPRE),
        .RST(RST),
        .SEL(SEL),
        .DATA0(DATA0)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            LDCOMP = 0;
            LDPRE = 0;
            SEL = 0;
            DATA1 = 0;
            DATA2 = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: System Reset");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Free-running Increment");
            reset_dut();

            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: LDCOMP Load DATA1 (SEL=0) on match at 0");
            reset_dut();
            LDCOMP = 1;
            SEL = 0;
            DATA1 = 8'hA5;
            DATA2 = 8'hFF;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: LDPRE and Load via High Register (SEL=1)");
            reset_dut();

            LDPRE = 1;
            DATA1 = 8'h77;
            @(posedge CLK);
            #1;
            LDPRE = 0;

            LDCOMP = 1;
            SEL = 1;
            DATA2 = 8'hEE;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Increment when not matching reg_low");
            reset_dut();

            LDCOMP = 1;
            SEL = 0;
            DATA1 = 8'd10;
            DATA2 = 8'd20;
            @(posedge CLK);
            #1;

            LDCOMP = 0;
            repeat(3) @(posedge CLK);
            #1;

            #1;


            check_outputs(8'd13);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Wait for match and then load");
            reset_dut();

            LDCOMP = 1;
            SEL = 0;
            DATA1 = 8'd10;
            DATA2 = 8'd12;
            @(posedge CLK);
            #1;
            LDCOMP = 0;

            @(posedge CLK); #1;

            @(posedge CLK); #1;

            LDCOMP = 1;
            DATA1 = 8'hCC;
            SEL = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(8'hCC);
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
        input [7:0] expected_DATA0;
        begin
            if (expected_DATA0 === (expected_DATA0 ^ DATA0 ^ expected_DATA0)) begin
                $display("PASS");
                $display("  Outputs: DATA0=%h",
                         DATA0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA0=%h",
                         expected_DATA0);
                $display("  Got:      DATA0=%h",
                         DATA0);
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
        $dumpvars(0,CLK, DATA1, DATA2, LDCOMP, LDPRE, RST, SEL, DATA0);
    end

endmodule
