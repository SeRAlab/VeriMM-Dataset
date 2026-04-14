`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] funcion_conf;
    wire cs_dia_fecha;
    wire cs_hora_hora;
    wire cs_hora_timer;
    wire cs_jahr_fecha;
    wire cs_mes_fecha;
    wire cs_min_hora;
    wire cs_min_timer;
    wire cs_seg_hora;
    wire cs_seg_timer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .funcion_conf(funcion_conf),
        .cs_dia_fecha(cs_dia_fecha),
        .cs_hora_hora(cs_hora_hora),
        .cs_hora_timer(cs_hora_timer),
        .cs_jahr_fecha(cs_jahr_fecha),
        .cs_mes_fecha(cs_mes_fecha),
        .cs_min_hora(cs_min_hora),
        .cs_min_timer(cs_min_timer),
        .cs_seg_hora(cs_seg_hora),
        .cs_seg_timer(cs_seg_timer)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: funcion_conf = 2'b00 (Select Time registers)");
        funcion_conf = 2'b00;



        #1;




        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: funcion_conf = 2'b01 (Select Date registers)");
        funcion_conf = 2'b01;


        #1;



        check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: funcion_conf = 2'b10 (Select Timer registers)");
        funcion_conf = 2'b10;


        #1;



        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: funcion_conf = 2'b11 (Invalid/Idle state)");
        funcion_conf = 2'b11;


        #1;



        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_cs_dia_fecha;
        input expected_cs_hora_hora;
        input expected_cs_hora_timer;
        input expected_cs_jahr_fecha;
        input expected_cs_mes_fecha;
        input expected_cs_min_hora;
        input expected_cs_min_timer;
        input expected_cs_seg_hora;
        input expected_cs_seg_timer;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cs_dia_fecha === (expected_cs_dia_fecha ^ cs_dia_fecha ^ expected_cs_dia_fecha) &&
                expected_cs_hora_hora === (expected_cs_hora_hora ^ cs_hora_hora ^ expected_cs_hora_hora) &&
                expected_cs_hora_timer === (expected_cs_hora_timer ^ cs_hora_timer ^ expected_cs_hora_timer) &&
                expected_cs_jahr_fecha === (expected_cs_jahr_fecha ^ cs_jahr_fecha ^ expected_cs_jahr_fecha) &&
                expected_cs_mes_fecha === (expected_cs_mes_fecha ^ cs_mes_fecha ^ expected_cs_mes_fecha) &&
                expected_cs_min_hora === (expected_cs_min_hora ^ cs_min_hora ^ expected_cs_min_hora) &&
                expected_cs_min_timer === (expected_cs_min_timer ^ cs_min_timer ^ expected_cs_min_timer) &&
                expected_cs_seg_hora === (expected_cs_seg_hora ^ cs_seg_hora ^ expected_cs_seg_hora) &&
                expected_cs_seg_timer === (expected_cs_seg_timer ^ cs_seg_timer ^ expected_cs_seg_timer)) begin
                $display("PASS");
                $display("  Outputs: cs_dia_fecha=%b, cs_hora_hora=%b, cs_hora_timer=%b, cs_jahr_fecha=%b, cs_mes_fecha=%b, cs_min_hora=%b, cs_min_timer=%b, cs_seg_hora=%b, cs_seg_timer=%b",
                         cs_dia_fecha, cs_hora_hora, cs_hora_timer, cs_jahr_fecha, cs_mes_fecha, cs_min_hora, cs_min_timer, cs_seg_hora, cs_seg_timer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cs_dia_fecha=%b, cs_hora_hora=%b, cs_hora_timer=%b, cs_jahr_fecha=%b, cs_mes_fecha=%b, cs_min_hora=%b, cs_min_timer=%b, cs_seg_hora=%b, cs_seg_timer=%b",
                         expected_cs_dia_fecha, expected_cs_hora_hora, expected_cs_hora_timer, expected_cs_jahr_fecha, expected_cs_mes_fecha, expected_cs_min_hora, expected_cs_min_timer, expected_cs_seg_hora, expected_cs_seg_timer);
                $display("  Got:      cs_dia_fecha=%b, cs_hora_hora=%b, cs_hora_timer=%b, cs_jahr_fecha=%b, cs_mes_fecha=%b, cs_min_hora=%b, cs_min_timer=%b, cs_seg_hora=%b, cs_seg_timer=%b",
                         cs_dia_fecha, cs_hora_hora, cs_hora_timer, cs_jahr_fecha, cs_mes_fecha, cs_min_hora, cs_min_timer, cs_seg_hora, cs_seg_timer);
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

endmodule
