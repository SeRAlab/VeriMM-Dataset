`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] direccion_actual;
    reg [1:0] interruptor_sinc;
    wire [3:0] datos_por_escribir;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .direccion_actual(direccion_actual),
        .interruptor_sinc(interruptor_sinc),
        .datos_por_escribir(datos_por_escribir)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: interruptor_sinc = 00", test_num);
        interruptor_sinc = 2'b00;
        direccion_actual = 4'b0000;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: interruptor_sinc = 01", test_num);
        interruptor_sinc = 2'b01;
        direccion_actual = 4'b1111;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: interruptor_sinc = 10", test_num);
        interruptor_sinc = 2'b10;
        direccion_actual = 4'b0110;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: interruptor_sinc = 11, direccion_actual = 4'b1100", test_num);
        interruptor_sinc = 2'b11;
        direccion_actual = 4'b1100;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: interruptor_sinc = 11, direccion_actual = 4'b0011", test_num);
        interruptor_sinc = 2'b11;
        direccion_actual = 4'b0011;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: interruptor_sinc = 00, changing direccion_actual", test_num);
        interruptor_sinc = 2'b00;
        direccion_actual = 4'b1001;
        #1;

        check_outputs(4'b0101);
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
        input [3:0] expected_datos_por_escribir;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_datos_por_escribir === (expected_datos_por_escribir ^ datos_por_escribir ^ expected_datos_por_escribir)) begin
                $display("PASS");
                $display("  Outputs: datos_por_escribir=%h",
                         datos_por_escribir);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: datos_por_escribir=%h",
                         expected_datos_por_escribir);
                $display("  Got:      datos_por_escribir=%h",
                         datos_por_escribir);
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
