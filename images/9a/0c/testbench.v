`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg CLKOUTseg;
    reg De;
    reg U;
    reg [3:0] centenas;
    reg [3:0] decenas;
    reg [3:0] unidades;
    wire [3:0] digito;
    wire [1:0] mostrar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C(C),
        .CLKOUTseg(CLKOUTseg),
        .De(De),
        .U(U),
        .centenas(centenas),
        .decenas(decenas),
        .unidades(unidades),
        .digito(digito),
        .mostrar(mostrar)
    );

    // Clock generation (10ns period)
    initial begin
        CLKOUTseg = 0;
        forever #5 CLKOUTseg = ~CLKOUTseg;
    end

        task reset_dut;

        begin
            C = 0;
            De = 0;
            U = 0;
            centenas = 4'h0;
            decenas = 4'h0;
            unidades = 4'h0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Direct Units Display (U=1)", test_num);
            unidades = 4'h3;
            decenas  = 4'h2;
            centenas = 4'h1;
            U = 1; De = 0; C = 0;
            #11;
            #1;

            check_outputs(4'h3, 2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Direct Tens Display (De=1)", test_num);
            unidades = 4'h9;
            decenas  = 4'h5;
            centenas = 4'h2;
            U = 0; De = 1; C = 0;
            #11;
            #1;

            check_outputs(4'h5, 2'b01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Direct Hundreds Display (C=1)", test_num);
            unidades = 4'h8;
            decenas  = 4'h7;
            centenas = 4'h6;
            U = 0; De = 0; C = 1;
            #11;
            #1;

            check_outputs(4'h6, 2'b10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Cycling Mode - Step 1", test_num);
            unidades = 4'hA; decenas = 4'hB; centenas = 4'hC;
            C = 1; De = 1; U = 1;

            @(posedge CLKOUTseg);
            #2;
            #1;

            check_outputs(4'hA, 2'b00);
        end
        endtask

    task testcase005;

        begin

            test_num = 5;
            $display("Testcase %0d: Cycling Mode - Step 2", test_num);
            unidades = 4'hA; decenas = 4'hB; centenas = 4'hC;
            C = 1; De = 1; U = 1;
            @(posedge CLKOUTseg);
            #2;
            #1;

            check_outputs(4'hB, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Cycling Mode - Step 3", test_num);
            unidades = 4'hA; decenas = 4'hB; centenas = 4'hC;
            C = 1; De = 1; U = 1;
            @(posedge CLKOUTseg);
            #2;
            #1;

            check_outputs(4'hC, 2'b10);
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
        input [3:0] expected_digito;
        input [1:0] expected_mostrar;
        begin
            if (expected_digito === (expected_digito ^ digito ^ expected_digito) &&
                expected_mostrar === (expected_mostrar ^ mostrar ^ expected_mostrar)) begin
                $display("PASS");
                $display("  Outputs: digito=%h, mostrar=%h",
                         digito, mostrar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digito=%h, mostrar=%h",
                         expected_digito, expected_mostrar);
                $display("  Got:      digito=%h, mostrar=%h",
                         digito, mostrar);
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
        $dumpvars(0,C, CLKOUTseg, De, U, centenas, decenas, unidades, digito, mostrar);
    end

endmodule
