`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] add1;
    reg [31:0] shift;
    wire [31:0] salida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add1(add1),
        .shift(shift),
        .salida(salida)
    );
    task testcase001;

    begin
        test_num = 1;
        add1 = 32'h00000000;
        shift = 32'h00000000;
        $display("Test %0d: %h + %h", test_num, add1, shift);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        add1 = 32'd1234;
        shift = 32'd5678;
        $display("Test %0d: %d + %d", test_num, add1, shift);
        #1;

        check_outputs(32'd6912);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        add1 = 32'hFFFFFFFF;
        shift = 32'h00000001;
        $display("Test %0d: %h + %h (Overflow expected)", test_num, add1, shift);

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        add1 = 32'h70000000;
        shift = 32'h0FFFFFFF;
        $display("Test %0d: %h + %h", test_num, add1, shift);
        #1;

        check_outputs(32'h7FFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        add1 = 32'hFFFFFFFF;
        shift = 32'hFFFFFFFF;
        $display("Test %0d: %h + %h", test_num, add1, shift);

        #1;


        check_outputs(32'hFFFFFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        add1 = 32'hAAAAAAAA;
        shift = 32'h55555555;
        $display("Test %0d: %h + %h", test_num, add1, shift);
        #1;

        check_outputs(32'hFFFFFFFF);
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
