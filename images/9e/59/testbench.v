`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] selector;
    wire [2:0] salida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .selector(selector),
        .salida(salida)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Selector = 0", test_num);
            selector = 2'b00;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Selector = 1", test_num);
            selector = 2'b01;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Selector = 2", test_num);
            selector = 2'b10;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Selector = 3", test_num);
            selector = 2'b11;
            #1;

            check_outputs(3'b110);
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
        input [2:0] expected_salida;
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
