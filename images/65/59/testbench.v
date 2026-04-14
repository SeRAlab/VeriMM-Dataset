`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock_50mhz;
    wire [3:0] anodos;
    wire clock_1hz;
    wire [3:0] estado;
    wire [6:0] segmentos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_50mhz(clock_50mhz),
        .anodos(anodos),
        .clock_1hz(clock_1hz),
        .estado(estado),
        .segmentos(segmentos)
    );

    // Clock generation (10ns period)
    initial begin
        clock_50mhz = 0;
        forever #5 clock_50mhz = ~clock_50mhz;
    end

        task reset_dut;

        begin


            $display("Resetting/Initializing DUT...");
            repeat (10) @(posedge clock_50mhz);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Initial State Check", test_num);
            reset_dut();




            #1;





            check_outputs(4'b1110, 1'b0, 4'h0, 7'h3f);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Anode Multiplexing Check", test_num);
            reset_dut();



            repeat (1000) @(posedge clock_50mhz);
            #1;



            #1;




            check_outputs(4'b1101, 1'b0, 4'h0, 7'h3f);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: State Stability Check", test_num);
            reset_dut();



            repeat (10000) @(posedge clock_50mhz);
            #1;



            if (estado === 4'h0 && clock_1hz === 1'b0) begin
                $display("PASS: State stable at 0 after 200us");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: State changed or clock toggled too early. Got: estado=%h, clk1hz=%b", estado, clock_1hz);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %04d: Segment Pattern Check", test_num);
            reset_dut();



            if (segmentos !== 7'b0000000) begin
                $display("PASS: Segmentos is driving a pattern (Got: %h)", segmentos);
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: Segmentos is blank/zero");
                fail_count = fail_count + 1;
            end
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
        input [3:0] expected_anodos;
        input expected_clock_1hz;
        input [3:0] expected_estado;
        input [6:0] expected_segmentos;
        begin
            if (expected_anodos === (expected_anodos ^ anodos ^ expected_anodos) &&
                expected_clock_1hz === (expected_clock_1hz ^ clock_1hz ^ expected_clock_1hz) &&
                expected_estado === (expected_estado ^ estado ^ expected_estado) &&
                expected_segmentos === (expected_segmentos ^ segmentos ^ expected_segmentos)) begin
                $display("PASS");
                $display("  Outputs: anodos=%h, clock_1hz=%b, estado=%h, segmentos=%h",
                         anodos, clock_1hz, estado, segmentos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: anodos=%h, clock_1hz=%b, estado=%h, segmentos=%h",
                         expected_anodos, expected_clock_1hz, expected_estado, expected_segmentos);
                $display("  Got:      anodos=%h, clock_1hz=%b, estado=%h, segmentos=%h",
                         anodos, clock_1hz, estado, segmentos);
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
        $dumpvars(0,clock_50mhz, anodos, clock_1hz, estado, segmentos);
    end

endmodule
