`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Extsel;
    reg [15:0] Imme;
    wire [31:0] ExtendOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Extsel(Extsel),
        .Imme(Imme),
        .ExtendOut(ExtendOut)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero extension with positive value", test_num);
            Extsel = 0;
            Imme = 16'h1234;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Zero extension with MSB=1", test_num);
            Extsel = 0;
            Imme = 16'hABCD;
            #1;

            check_outputs(32'h0000ABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sign extension with positive value (MSB=0)", test_num);
            Extsel = 1;
            Imme = 16'h7FFF;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sign extension with negative value (MSB=1)", test_num);
            Extsel = 1;
            Imme = 16'h8000;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Zero extension with all ones", test_num);
            Extsel = 0;
            Imme = 16'hFFFF;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sign extension with all ones", test_num);
            Extsel = 1;
            Imme = 16'hFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Zero extension with all zeros", test_num);
            Extsel = 0;
            Imme = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Sign extension with all zeros", test_num);
            Extsel = 1;
            Imme = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Zero extension boundary value", test_num);
            Extsel = 0;
            Imme = 16'h5A5A;
            #1;

            check_outputs(32'h00005A5A);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Sign extension boundary value", test_num);
            Extsel = 1;
            Imme = 16'hA5A5;
            #1;

            check_outputs(32'hFFFFA5A5);
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
        testcase010();
        
        
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
        input [31:0] expected_ExtendOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ExtendOut === (expected_ExtendOut ^ ExtendOut ^ expected_ExtendOut)) begin
                $display("PASS");
                $display("  Outputs: ExtendOut=%h",
                         ExtendOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ExtendOut=%h",
                         expected_ExtendOut);
                $display("  Got:      ExtendOut=%h",
                         ExtendOut);
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
