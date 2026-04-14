`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Dato_Boton;
    reg [7:0] Dato_RTC;
    reg Select;
    wire [7:0] Dato_vga;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Dato_Boton(Dato_Boton),
        .Dato_RTC(Dato_RTC),
        .Select(Select),
        .Dato_vga(Dato_vga)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Dato_RTC (Select=0)", test_num);
            Dato_RTC = 8'hA5;
            Dato_Boton = 8'h5A;
            Select = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Dato_Boton (Select=1)", test_num);
            Dato_RTC = 8'hA5;
            Dato_Boton = 8'h5A;
            Select = 1'b1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros, Select RTC", test_num);
            Dato_RTC = 8'h00;
            Dato_Boton = 8'hFF;
            Select = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones, Select Boton", test_num);
            Dato_RTC = 8'h00;
            Dato_Boton = 8'hFF;
            Select = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits, Select RTC", test_num);
            Dato_RTC = 8'b10101010;
            Dato_Boton = 8'b01010101;
            Select = 1'b0;
            #1;

            check_outputs(8'b10101010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits, Select Boton", test_num);
            Dato_RTC = 8'b10101010;
            Dato_Boton = 8'b01010101;
            Select = 1'b1;
            #1;

            check_outputs(8'b01010101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Values 1, Select RTC", test_num);
            Dato_RTC = 8'hDE;
            Dato_Boton = 8'hAD;
            Select = 1'b0;
            #1;

            check_outputs(8'hDE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Values 2, Select Boton", test_num);
            Dato_RTC = 8'hBE;
            Dato_Boton = 8'hEF;
            Select = 1'b1;
            #1;

            check_outputs(8'hEF);
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
        input [7:0] expected_Dato_vga;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Dato_vga === (expected_Dato_vga ^ Dato_vga ^ expected_Dato_vga)) begin
                $display("PASS");
                $display("  Outputs: Dato_vga=%h",
                         Dato_vga);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dato_vga=%h",
                         expected_Dato_vga);
                $display("  Got:      Dato_vga=%h",
                         Dato_vga);
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
