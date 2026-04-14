`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addra;
    reg clka;
    reg [3:0] dina;
    reg ena;
    wire [3:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .clka(clka),
        .dina(dina),
        .ena(ena),
        .douta(douta)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

        task reset_dut;

        begin
            ena = 0;
            addra = 0;
            dina = 0;

            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            ena = 1;
            addra = 4'h5;
            dina = 4'hA;
            @(posedge clka);
            #1;


            ena = 0;
            @(posedge clka);
            #1;

            $display("Testcase 001: Basic Write/Read at Address 5");
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            ena = 1;
            addra = 4'h3;
            dina = 4'h7;
            @(posedge clka);
            #1;


            ena = 0;
            addra = 4'h3;
            dina = 4'hE;
            @(posedge clka);
            #1;


            @(posedge clka);
            #1;

            $display("Testcase 002: Verify Write Enable functionality");
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            ena = 1;
            addra = 4'hF;
            dina = 4'hC;
            @(posedge clka);
            #1;

            ena = 0;
            addra = 4'hF;
            @(posedge clka);
            #1;

            $display("Testcase 003: Boundary Check at Address 15");
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            ena = 1;
            addra = 4'h8;
            dina = 4'h1;
            @(posedge clka);
            #1;


            ena = 1;
            addra = 4'h8;
            dina = 4'h9;
            @(posedge clka);
            #1;


            ena = 0;
            addra = 4'h8;
            @(posedge clka);
            #1;

            $display("Testcase 004: Data Overwrite at Address 8");
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            ena = 1;
            addra = 4'h0;
            dina = 4'h4;
            @(posedge clka);
            #1;


            ena = 0;
            addra = 4'h0;
            @(posedge clka);
            #1;

            $display("Testcase 005: Read from Address 0");
            #1;

            check_outputs(4'h4);
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
        input [3:0] expected_douta;
        begin
            if (expected_douta === (expected_douta ^ douta ^ expected_douta)) begin
                $display("PASS");
                $display("  Outputs: douta=%h",
                         douta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: douta=%h",
                         expected_douta);
                $display("  Got:      douta=%h",
                         douta);
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
        $dumpvars(0,addra, clka, dina, ena, douta);
    end

endmodule
