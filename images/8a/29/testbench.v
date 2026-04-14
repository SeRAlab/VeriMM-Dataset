`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] numeros;
    wire [15:0] operador;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .numeros(numeros),
        .operador(operador)
    );
    task testcase001;

        begin
            test_num = 1;
            numeros = 20'h00000;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            numeros = 20'h00005;
            #1;

            check_outputs(16'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            numeros = 20'h00070;
            #1;

            check_outputs(16'd70);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            numeros = 20'h00300;
            #1;

            check_outputs(16'd300);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            numeros = 20'h04000;
            #1;

            check_outputs(16'd4000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            numeros = 20'h20000;
            #1;

            check_outputs(16'd20000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            numeros = 20'h12345;
            #1;

            check_outputs(16'd12345);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            numeros = 20'h65535;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            numeros = 20'h09999;
            #1;

            check_outputs(16'd9999);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            numeros = 20'h99999;
            #1;

            check_outputs(16'h869F);
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
        testcase010();
        
        
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
        input [15:0] expected_operador;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_operador === (expected_operador ^ operador ^ expected_operador)) begin
                $display("PASS");
                $display("  Outputs: operador=%h",
                         operador);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: operador=%h",
                         expected_operador);
                $display("  Got:      operador=%h",
                         operador);
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
