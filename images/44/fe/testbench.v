`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] dato;
    reg [7:0] direccion;
    reg seleccion;
    wire [7:0] salida_bus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dato(dato),
        .direccion(direccion),
        .seleccion(seleccion),
        .salida_bus(salida_bus)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Select direccion (seleccion=0)", test_num);
            direccion = 8'hA5;
            dato = 8'h3C;
            seleccion = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Select dato (seleccion=1)", test_num);
            direccion = 8'hA5;
            dato = 8'h3C;
            seleccion = 1'b1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros selection", test_num);
            direccion = 8'h00;
            dato = 8'hFF;
            seleccion = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones selection", test_num);
            direccion = 8'h00;
            dato = 8'hFF;
            seleccion = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits - select direccion", test_num);
            direccion = 8'hAA;
            dato = 8'h55;
            seleccion = 1'b0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits - select dato", test_num);
            direccion = 8'hAA;
            dato = 8'h55;
            seleccion = 1'b1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking bit pattern", test_num);
            direccion = 8'h01;
            dato = 8'h80;
            seleccion = 1'b0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data isolation check (seleccion=0)", test_num);
            direccion = 8'h77;
            dato = 8'h00;
            seleccion = 1'b0;
            #5;
            dato = 8'hFF;
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address isolation check (seleccion=1)", test_num);
            direccion = 8'h00;
            dato = 8'hBB;
            seleccion = 1'b1;
            #5;
            direccion = 8'hFF;
            #1;

            check_outputs(8'hBB);
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
        testcase008();
        testcase009();
        
        
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
        input [7:0] expected_salida_bus;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_salida_bus === (expected_salida_bus ^ salida_bus ^ expected_salida_bus)) begin
                $display("PASS");
                $display("  Outputs: salida_bus=%h",
                         salida_bus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: salida_bus=%h",
                         expected_salida_bus);
                $display("  Got:      salida_bus=%h",
                         salida_bus);
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
