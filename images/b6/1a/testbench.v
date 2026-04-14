`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] decenas;
    reg [7:0] ignicion;
    reg [7:0] presencia;
    reg rst;
    reg [7:0] unidades;
    wire Carro;
    wire Pres;
    wire [4:0] Temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .decenas(decenas),
        .ignicion(ignicion),
        .presencia(presencia),
        .rst(rst),
        .unidades(unidades),
        .Carro(Carro),
        .Pres(Pres),
        .Temp(Temp)
    );
    task testcase001;

        begin
            test_num = 1;
            rst = 1;
            decenas = 8'h32;
            unidades = 8'h35;
            presencia = 8'hFF;
            ignicion = 8'hFF;
            #10;
            #1;

            check_outputs(1'b0, 1'b0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            rst = 0;
            decenas = 8'h30;
            unidades = 8'h30;
            presencia = 8'h00;
            ignicion = 8'h00;
            #10;
            #1;

            check_outputs(1'b0, 1'b0, 5'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            rst = 0;
            decenas = 8'h31;
            unidades = 8'h35;
            presencia = 8'h01;
            ignicion = 8'h00;
            #10;

            #1;


            check_outputs(1'b0, 1'b1, 5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            rst = 0;
            decenas = 8'h33;
            unidades = 8'h31;
            presencia = 8'h00;
            ignicion = 8'h01;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            rst = 0;
            decenas = 8'h32;
            unidades = 8'h30;
            presencia = 8'hAA;
            ignicion = 8'h55;
            #10;

            #1;


            check_outputs(1'b1, 1'b1, 5'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            rst = 0;
            decenas = 8'h30;
            unidades = 8'h39;
            presencia = 8'h00;
            ignicion = 8'hFF;
            #10;
            #1;

            check_outputs(1'b1, 1'b0, 5'd9);
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
        input expected_Carro;
        input expected_Pres;
        input [4:0] expected_Temp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Carro === (expected_Carro ^ Carro ^ expected_Carro) &&
                expected_Pres === (expected_Pres ^ Pres ^ expected_Pres) &&
                expected_Temp === (expected_Temp ^ Temp ^ expected_Temp)) begin
                $display("PASS");
                $display("  Outputs: Carro=%b, Pres=%b, Temp=%h",
                         Carro, Pres, Temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Carro=%b, Pres=%b, Temp=%h",
                         expected_Carro, expected_Pres, expected_Temp);
                $display("  Got:      Carro=%b, Pres=%b, Temp=%h",
                         Carro, Pres, Temp);
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
