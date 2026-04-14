`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addra;
    reg [9:0] addrb;
    reg clk;
    reg [15:0] dia;
    reg ena;
    reg enb;
    reg wea;
    wire [15:0] dob;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .addrb(addrb),
        .clk(clk),
        .dia(dia),
        .ena(ena),
        .enb(enb),
        .wea(wea),
        .dob(dob)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ena = 0;
            enb = 0;
            wea = 0;
            addra = 0;
            addrb = 0;
            dia = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            ena = 1;
            wea = 1;
            addra = 10'h010;
            dia = 16'hABCD;
            @(posedge clk);
            #1;


            wea = 0;
            ena = 0;


            enb = 1;
            addrb = 10'h010;
            @(posedge clk);
            #2;

            $display("Testcase 001: Basic Write and Read");
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            ena = 1;
            wea = 1;
            addra = 10'h020;
            dia = 16'h1234;
            @(posedge clk);
            #1;


            ena = 1;
            wea = 1;
            addra = 10'h030;
            dia = 16'h5678;

            enb = 1;
            addrb = 10'h020;
            @(posedge clk);
            #2;

            $display("Testcase 002: Concurrent Read and Write (diff addresses)");
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            ena = 1;
            wea = 1;
            addra = 10'h040;
            dia = 16'hAAAA;
            @(posedge clk);
            #1;


            wea = 0;
            dia = 16'hBBBB;
            @(posedge clk);
            #1;


            enb = 1;
            addrb = 10'h040;
            @(posedge clk);
            #2;

            $display("Testcase 003: Check wea (Write Enable) control");
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            ena = 1;
            wea = 1;
            addra = 10'h050;
            dia = 16'hC0DE;
            @(posedge clk);
            #1;


            ena = 0;
            wea = 1;
            dia = 16'hDEAD;
            @(posedge clk);
            #1;


            enb = 1;
            addrb = 10'h050;
            @(posedge clk);
            #2;

            $display("Testcase 004: Check ena (Port A Enable) control");
            #1;

            check_outputs(16'hC0DE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            ena = 1;
            wea = 1;
            addra = 10'd1023;
            dia = 16'hFFFF;
            @(posedge clk);
            #1;


            enb = 1;
            addrb = 10'd1023;
            @(posedge clk);
            #2;

            $display("Testcase 005: Boundary Address (1023)");
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            ena = 1;
            wea = 1;
            addra = 10'h100; dia = 16'h1111; @(posedge clk); #1;
            addra = 10'h101; dia = 16'h2222; @(posedge clk); #1;
            addra = 10'h102; dia = 16'h3333; @(posedge clk); #1;

            ena = 0;
            wea = 0;
            enb = 1;
            addrb = 10'h101;
            @(posedge clk);
            #2;

            $display("Testcase 006: Sequential multi-write sequence");
            #1;

            check_outputs(16'h2222);
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
        input [15:0] expected_dob;
        begin
            if (expected_dob === (expected_dob ^ dob ^ expected_dob)) begin
                $display("PASS");
                $display("  Outputs: dob=%h",
                         dob);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dob=%h",
                         expected_dob);
                $display("  Got:      dob=%h",
                         dob);
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
        $dumpvars(0,addra, addrb, clk, dia, ena, enb, wea, dob);
    end

endmodule
