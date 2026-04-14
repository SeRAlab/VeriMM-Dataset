`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IF_ID_Write;
    reg clock;
    reg [31:0] instruccion;
    reg [10:0] pc;
    wire [31:0] salida_inst;
    wire [10:0] salida_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IF_ID_Write(IF_ID_Write),
        .clock(clock),
        .instruccion(instruccion),
        .pc(pc),
        .salida_inst(salida_inst),
        .salida_pc(salida_pc)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            IF_ID_Write = 0;
            instruccion = 32'h0;
            pc = 11'h0;

            @(negedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write Operation");
            reset_dut();
            test_num = 1;

            IF_ID_Write = 1;
            instruccion = 32'hDEADBEEF;
            pc = 11'h7FF;


            @(negedge clock);
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 11'h7FF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write Disable (Stall) Operation");
            reset_dut();
            test_num = 2;


            IF_ID_Write = 1;
            instruccion = 32'h11112222;
            pc = 11'h100;
            @(negedge clock);
            #2;


            IF_ID_Write = 0;
            instruccion = 32'hFFFFFFFF;
            pc = 11'h555;
            @(negedge clock);
            #2;


            #1;



            check_outputs(32'h11112222, 11'h100);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Boundary Values (All Ones)");
            reset_dut();
            test_num = 3;

            IF_ID_Write = 1;
            instruccion = 32'hFFFFFFFF;
            pc = 11'h7FF;

            @(negedge clock);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 11'h7FF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Sequential Updates");
            reset_dut();
            test_num = 4;

            IF_ID_Write = 1;


            instruccion = 32'hAAAA0000; pc = 11'h010;
            @(negedge clock);


            instruccion = 32'h0000BBBB; pc = 11'h020;
            @(negedge clock);


            instruccion = 32'h12345678; pc = 11'h030;
            @(negedge clock);
            #2;

            #1;


            check_outputs(32'h12345678, 11'h030);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Write Enable Toggle Logic");
            reset_dut();
            test_num = 5;


            instruccion = 32'hCAFEFACE;
            pc = 11'h456;


            #2;
            IF_ID_Write = 0;
            #2;
            IF_ID_Write = 1;

            @(negedge clock);
            #2;

            #1;


            check_outputs(32'hCAFEFACE, 11'h456);
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
        input [31:0] expected_salida_inst;
        input [10:0] expected_salida_pc;
        begin
            if (expected_salida_inst === (expected_salida_inst ^ salida_inst ^ expected_salida_inst) &&
                expected_salida_pc === (expected_salida_pc ^ salida_pc ^ expected_salida_pc)) begin
                $display("PASS");
                $display("  Outputs: salida_inst=%h, salida_pc=%h",
                         salida_inst, salida_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: salida_inst=%h, salida_pc=%h",
                         expected_salida_inst, expected_salida_pc);
                $display("  Got:      salida_inst=%h, salida_pc=%h",
                         salida_inst, salida_pc);
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
        $dumpvars(0,IF_ID_Write, clock, instruccion, pc, salida_inst, salida_pc);
    end

endmodule
