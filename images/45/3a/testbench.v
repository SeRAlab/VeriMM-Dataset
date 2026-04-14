`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Dato;
    wire [7:0] Datoconv;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Dato(Dato),
        .Datoconv(Datoconv)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 0", test_num);
            Dato = 8'd0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 5", test_num);
            Dato = 8'd5;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 9 (Threshold)", test_num);
            Dato = 8'd9;
            #1;

            check_outputs(8'h09);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 10 (First BCD Adjustment)", test_num);
            Dato = 8'd10;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 15", test_num);
            Dato = 8'd15;
            #1;

            check_outputs(8'h15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 19", test_num);
            Dato = 8'd19;
            #1;

            check_outputs(8'h19);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 20", test_num);
            Dato = 8'd20;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 48", test_num);
            Dato = 8'd48;
            #1;

            check_outputs(8'h48);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 99 (Max 2-digit BCD)", test_num);
            Dato = 8'd99;
            #1;

            check_outputs(8'h99);
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
        input [7:0] expected_Datoconv;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Datoconv === (expected_Datoconv ^ Datoconv ^ expected_Datoconv)) begin
                $display("PASS");
                $display("  Outputs: Datoconv=%h",
                         Datoconv);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Datoconv=%h",
                         expected_Datoconv);
                $display("  Got:      Datoconv=%h",
                         Datoconv);
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
