`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] entrada_0;
    reg [3:0] entrada_1;
    reg [3:0] sequencia_0;
    reg [3:0] sequencia_1;
    wire saida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .entrada_0(entrada_0),
        .entrada_1(entrada_1),
        .sequencia_0(sequencia_0),
        .sequencia_1(sequencia_1),
        .saida(saida)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Perfect Match - Both sequences match references", test_num);
            sequencia_0 = 4'b1010;
            entrada_0   = 4'b1010;
            sequencia_1 = 4'b0110;
            entrada_1   = 4'b0110;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mismatch in sequence 1 - sequence 0 matches", test_num);
            sequencia_0 = 4'b1111;
            entrada_0   = 4'b1111;
            sequencia_1 = 4'b0000;
            entrada_1   = 4'b0001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mismatch in sequence 0 - sequence 1 matches", test_num);
            sequencia_0 = 4'b1011;
            entrada_0   = 4'b1010;
            sequencia_1 = 4'b1100;
            entrada_1   = 4'b1100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mismatch in both sequences", test_num);
            sequencia_0 = 4'b0101;
            entrada_0   = 4'b1010;
            sequencia_1 = 4'b0011;
            entrada_1   = 4'b1100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros match", test_num);
            sequencia_0 = 4'b0000;
            entrada_0   = 4'b0000;
            sequencia_1 = 4'b0000;
            entrada_1   = 4'b0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones match", test_num);
            sequencia_0 = 4'b1111;
            entrada_0   = 4'b1111;
            sequencia_1 = 4'b1111;
            entrada_1   = 4'b1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit mismatch in entrada_0", test_num);
            sequencia_0 = 4'b1000;
            entrada_0   = 4'b1001;
            sequencia_1 = 4'b1111;
            entrada_1   = 4'b1111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit match", test_num);
            sequencia_0 = 4'b1010;
            entrada_0   = 4'b1010;
            sequencia_1 = 4'b0101;
            entrada_1   = 4'b0101;
            #1;

            check_outputs(1'b1);
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
        input expected_saida;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_saida === (expected_saida ^ saida ^ expected_saida)) begin
                $display("PASS");
                $display("  Outputs: saida=%b",
                         saida);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saida=%b",
                         expected_saida);
                $display("  Got:      saida=%b",
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
