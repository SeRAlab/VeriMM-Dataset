`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] entrada1;
    reg [8:0] entrada2;
    wire [8:0] salida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .entrada1(entrada1),
        .entrada2(entrada2),
        .salida(salida)
    );
    task testcase001;

        begin
            test_num = 1;
            entrada1 = 9'd10;
            entrada2 = 9'd5;
            #1;

            check_outputs(9'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            entrada1 = 9'd255;
            entrada2 = 9'd255;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            entrada1 = 9'd0;
            entrada2 = 9'd1;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            entrada1 = 9'd500;
            entrada2 = 9'd200;
            #1;

            check_outputs(9'd300);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            entrada1 = 9'h1FF;
            entrada2 = 9'h1FF;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            entrada1 = 9'h1FF;
            entrada2 = 9'h000;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            entrada1 = 9'd5;
            entrada2 = 9'd10;
            #1;

            check_outputs(9'd507);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            entrada1 = 9'd256;
            entrada2 = 9'd1;
            #1;

            check_outputs(9'd255);
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
        input [8:0] expected_salida;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_salida === (expected_salida ^ salida ^ expected_salida)) begin
                $display("PASS");
                $display("  Outputs: salida=%h",
                         salida);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: salida=%h",
                         expected_salida);
                $display("  Got:      salida=%h",
                         salida);
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
