`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] entrada;
    wire [6:0] saida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .entrada(entrada),
        .saida(saida)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input 00 (Display 0)", test_num);
            entrada = 2'b00;
            #10;
            #1;

            check_outputs(7'b0111111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input 01 (Display 1)", test_num);
            entrada = 2'b01;
            #10;
            #1;

            check_outputs(7'b0000110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input 10 (Display 2)", test_num);
            entrada = 2'b10;
            #10;
            #1;

            check_outputs(7'b1011011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input 11 (Display 3)", test_num);
            entrada = 2'b11;
            #10;
            #1;

            check_outputs(7'b1001111);
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
        input [6:0] expected_saida;
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
