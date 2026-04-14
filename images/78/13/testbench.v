`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg controle;
    reg [4:0] dado_contexto;
    reg [4:0] dado_reg;
    wire [4:0] saida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .controle(controle),
        .dado_contexto(dado_contexto),
        .dado_reg(dado_reg),
        .saida(saida)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select dado_reg (controle=0)", test_num);
            controle = 1'b0;
            dado_reg = 5'b01010;
            dado_contexto = 5'b10101;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select dado_contexto (controle=1)", test_num);
            controle = 1'b1;
            dado_reg = 5'b01010;
            dado_contexto = 5'b10101;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Boundary values (All 1s vs All 0s) - Select Reg", test_num);
            controle = 1'b0;
            dado_reg = 5'b11111;
            dado_contexto = 5'b00000;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Boundary values (All 1s vs All 0s) - Select Contexto", test_num);
            controle = 1'b1;
            dado_reg = 5'b11111;
            dado_contexto = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Alternating bit patterns - Select Contexto", test_num);
            controle = 1'b1;
            dado_reg = 5'b10001;
            dado_contexto = 5'b01110;
            #1;

            check_outputs(5'b01110);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Single bit change - Select Reg", test_num);
            controle = 1'b0;
            dado_reg = 5'b00100;
            dado_contexto = 5'b00000;
            #1;

            check_outputs(5'b00100);
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
        input [4:0] expected_saida;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_saida === (expected_saida ^ saida ^ expected_saida)) begin
                $display("PASS");
                $display("  Outputs: saida=%h",
                         saida);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saida=%h",
                         expected_saida);
                $display("  Got:      saida=%h",
                         saida);
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
