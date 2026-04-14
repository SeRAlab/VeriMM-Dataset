`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addra;
    reg clka;
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
        @(posedge clka);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase 001: Basic Read (Addr 0, Ena 1)");

        ena = 1;
        addra = 4'h0;

        @(posedge clka);
        #2;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase 002: Mid-range Address (Addr A, Ena 1)");

        ena = 1;
        addra = 4'hA;

        @(posedge clka);
        #2;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    reg [3:0] previous_val;
    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase 003: Enable Gate Check");


        ena = 1;
        addra = 4'h5;
        @(posedge clka);
        #1;
        previous_val = douta;


        ena = 0;
        addra = 4'hF;
        @(posedge clka);
        #2;


        #1;



        check_outputs(previous_val);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase 004: Boundary Address (Addr F, Ena 1)");

        ena = 1;
        addra = 4'hF;

        @(posedge clka);
        #2;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase 005: Sequential Rapid Read");

        ena = 1;
        addra = 4'h1;
        @(posedge clka);
        #1;
        addra = 4'h2;
        @(posedge clka);
        #2;


        #1;



        check_outputs(4'h2);
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
        $dumpvars(0,addra, clka, ena, douta);
    end

endmodule
