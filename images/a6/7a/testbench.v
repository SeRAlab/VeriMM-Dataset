`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] entrada_e1;
    reg [15:0] entrada_e2;
    reg hab_escrita;
    reg reset;
    wire [15:0] e1;
    wire [15:0] e2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .entrada_e1(entrada_e1),
        .entrada_e2(entrada_e2),
        .hab_escrita(hab_escrita),
        .reset(reset),
        .e1(e1),
        .e2(e2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            hab_escrita = 0;
            entrada_e1 = 0;
            entrada_e2 = 0;
            @(posedge clock);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: e1 > e2 Input", test_num);
            reset_dut();
            entrada_e1 = 16'hAAAA;
            entrada_e2 = 16'h5555;
            hab_escrita = 1;
            @(posedge clock);
            #1;
            hab_escrita = 0;
            #1;

            check_outputs(16'hAAAA, 16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: e1 < e2 Input (Sort Check)", test_num);
            reset_dut();
            entrada_e1 = 16'h1234;
            entrada_e2 = 16'hABCD;
            hab_escrita = 1;
            @(posedge clock);
            #1;
            hab_escrita = 0;

            #1;


            check_outputs(16'hABCD, 16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Equal Inputs", test_num);
            reset_dut();
            entrada_e1 = 16'h7777;
            entrada_e2 = 16'h7777;
            hab_escrita = 1;
            @(posedge clock);
            #1;
            hab_escrita = 0;
            #1;

            check_outputs(16'h7777, 16'h7777);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write Enable Low Check", test_num);
            reset_dut();

            entrada_e1 = 16'hFFFF;
            entrada_e2 = 16'hEEEE;
            hab_escrita = 0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary Values", test_num);
            reset_dut();
            entrada_e1 = 16'h0000;
            entrada_e2 = 16'hFFFF;
            hab_escrita = 1;
            @(posedge clock);
            #1;
            hab_escrita = 0;
            #1;

            check_outputs(16'hFFFF, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Consecutive Updates", test_num);
            reset_dut();


            entrada_e1 = 16'h1000;
            entrada_e2 = 16'h2000;
            hab_escrita = 1;
            @(posedge clock);
            #1;


            entrada_e1 = 16'h5000;
            entrada_e2 = 16'h3000;
            @(posedge clock);
            #1;
            hab_escrita = 0;


            #1;



            check_outputs(16'h5000, 16'h3000);
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
        input [15:0] expected_e1;
        input [15:0] expected_e2;
        begin
            if (expected_e1 === (expected_e1 ^ e1 ^ expected_e1) &&
                expected_e2 === (expected_e2 ^ e2 ^ expected_e2)) begin
                $display("PASS");
                $display("  Outputs: e1=%h, e2=%h",
                         e1, e2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e1=%h, e2=%h",
                         expected_e1, expected_e2);
                $display("  Got:      e1=%h, e2=%h",
                         e1, e2);
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
        $dumpvars(0,clock, entrada_e1, entrada_e2, hab_escrita, reset, e1, e2);
    end

endmodule
