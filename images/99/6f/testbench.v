`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] BCD;
    reg [7:0] caracter_terminacion;
    reg signo;
    wire [47:0] mensaje;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BCD(BCD),
        .caracter_terminacion(caracter_terminacion),
        .signo(signo),
        .mensaje(mensaje)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Number 1234", test_num);
            BCD = 16'h1234;
            signo = 1'b1;
            caracter_terminacion = 8'h2E;
            #1;

            check_outputs(48'h2B313233342E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Number 5678", test_num);
            BCD = 16'h5678;
            signo = 1'b0;
            caracter_terminacion = 8'h00;
            #1;

            check_outputs(48'h2D3536373800);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Zero Padding 0009", test_num);
            BCD = 16'h0009;
            signo = 1'b1;
            caracter_terminacion = 8'h0A;
            #1;

            check_outputs(48'h2B303030390A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative All Zeros", test_num);
            BCD = 16'h0000;
            signo = 1'b0;
            caracter_terminacion = 8'h21;
            #1;

            check_outputs(48'h2D3030303021);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive High Digits 9999", test_num);
            BCD = 16'h9999;
            signo = 1'b1;
            caracter_terminacion = 8'h3B;
            #1;

            check_outputs(48'h2B393939393B);
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
        input [47:0] expected_mensaje;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mensaje === (expected_mensaje ^ mensaje ^ expected_mensaje)) begin
                $display("PASS");
                $display("  Outputs: mensaje=%h",
                         mensaje);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mensaje=%h",
                         expected_mensaje);
                $display("  Got:      mensaje=%h",
                         mensaje);
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
