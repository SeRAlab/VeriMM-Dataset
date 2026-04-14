`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] ADDRA;
    reg [5:0] ADDRB;
    reg E;
    reg ENB;
    reg Q;
    reg clk;
    reg [35:0] din;
    wire [35:0] DOUTB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDRA(ADDRA),
        .ADDRB(ADDRB),
        .E(E),
        .ENB(ENB),
        .Q(Q),
        .clk(clk),
        .din(din),
        .DOUTB(DOUTB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ADDRA = 0;
            ADDRB = 0;
            E = 0;
            ENB = 0;
            Q = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            ADDRA = 6'h05;
            din = 36'hA5A5A5A5A;
            E = 1;
            ENB = 1;
            @(posedge clk);
            #1;


            E = 0;
            ADDRB = 6'h05;
            @(posedge clk);
            #1;

            $display("Testcase 001: Basic Write/Read Address 05");
            #1;

            check_outputs(36'hA5A5A5A5A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            ADDRA = 6'h3F;
            din = 36'h123456789;
            E = 1;
            ENB = 1;
            @(posedge clk);
            #1;


            E = 0;
            ADDRB = 6'h3F;
            @(posedge clk);
            #1;

            $display("Testcase 002: Basic Write/Read Address 3F");
            #1;

            check_outputs(36'h123456789);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            ADDRA = 6'h10;
            din = 36'hFFFFFFFFF;
            E = 1;
            ENB = 0;
            @(posedge clk);
            #1;


            ENB = 1;
            E = 0;
            ADDRB = 6'h10;
            @(posedge clk);
            #1;

            $display("Testcase 003: Write with ENB=0 (Should fail)");
            #1;

            check_outputs(36'h000000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            ADDRA = 6'h15;
            din = 36'hCAFEBABE0;
            E = 0;
            ENB = 1;
            @(posedge clk);
            #1;


            ADDRB = 6'h15;
            @(posedge clk);
            #1;

            $display("Testcase 004: Write with E=0 (Should fail)");
            #1;

            check_outputs(36'h000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            ADDRA = 6'h01; din = 36'h111111111; E = 1; ENB = 1; @(posedge clk); #1;

            ADDRA = 6'h02; din = 36'h222222222; @(posedge clk); #1;

            ADDRA = 6'h03; din = 36'h333333333; @(posedge clk); #1;


            E = 0;
            ADDRB = 6'h02;
            @(posedge clk);
            #1;

            $display("Testcase 005: Sequence Write, Read Middle");
            #1;

            check_outputs(36'h222222222);
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
        input [35:0] expected_DOUTB;
        begin
            if (expected_DOUTB === (expected_DOUTB ^ DOUTB ^ expected_DOUTB)) begin
                $display("PASS");
                $display("  Outputs: DOUTB=%h",
                         DOUTB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUTB=%h",
                         expected_DOUTB);
                $display("  Got:      DOUTB=%h",
                         DOUTB);
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
        $dumpvars(0,ADDRA, ADDRB, E, ENB, Q, clk, din, DOUTB);
    end

endmodule
