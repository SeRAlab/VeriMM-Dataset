`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg aluSRC;
    reg [31:0] data0;
    reg [31:0] sing_ext1;
    wire [31:0] salida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluSRC(aluSRC),
        .data0(data0),
        .sing_ext1(sing_ext1),
        .salida(salida)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select data0", test_num);
        aluSRC = 1'b0;
        data0 = 32'hDEADBEEF;
        sing_ext1 = 32'h12345678;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select sing_ext1", test_num);
        aluSRC = 1'b1;
        data0 = 32'hDEADBEEF;
        sing_ext1 = 32'h12345678;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select all zeros", test_num);
        aluSRC = 1'b0;
        data0 = 32'h00000000;
        sing_ext1 = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select all ones", test_num);
        aluSRC = 1'b1;
        data0 = 32'h00000000;
        sing_ext1 = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bit patterns", test_num);
        aluSRC = 1'b0;
        data0 = 32'hAAAAAAAA;
        sing_ext1 = 32'h55555555;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative value selection (MSB=1)", test_num);
        aluSRC = 1'b1;
        data0 = 32'h00000001;
        sing_ext1 = 32'h80000000;
        #1;

        check_outputs(32'h80000000);
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
        input [31:0] expected_salida;
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
