`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [95:0] I1;
    reg [95:0] I2;
    reg Sel;
    wire [95:0] O1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I1(I1),
        .I2(I2),
        .Sel(Sel),
        .O1(O1)
    );
    task testcase001;

        begin
            $display("Testcase 001: Sel=0, I1=All Zeros, I2=All Ones");
            I1 = 96'h000000000000000000000000;
            I2 = 96'hFFFFFFFFFFFFFFFFFFFFFFFF;
            Sel = 1'b0;
            #5;
            #1;

            check_outputs(I1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Sel=1, I1=All Zeros, I2=All Ones");
            I1 = 96'h000000000000000000000000;
            I2 = 96'hFFFFFFFFFFFFFFFFFFFFFFFF;
            Sel = 1'b1;
            #5;
            #1;

            check_outputs(I2);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Sel=0, I1=Pattern A, I2=Pattern B");
            I1 = 96'hAAAAAAAAAAAAAAAAAAAAAAAA;
            I2 = 96'h555555555555555555555555;
            Sel = 1'b0;
            #5;
            #1;

            check_outputs(I1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Sel=1, I1=Pattern A, I2=Pattern B");
            I1 = 96'hAAAAAAAAAAAAAAAAAAAAAAAA;
            I2 = 96'h555555555555555555555555;
            Sel = 1'b1;
            #5;
            #1;

            check_outputs(I2);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Sel=0, Complex Data Patterns");
            I1 = 96'h123456789ABCDEF012345678;
            I2 = 96'hFEDCBA9876543210FEDCBA98;
            Sel = 1'b0;
            #5;
            #1;

            check_outputs(I1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Sel=1, Complex Data Patterns");
            I1 = 96'h123456789ABCDEF012345678;
            I2 = 96'hFEDCBA9876543210FEDCBA98;
            Sel = 1'b1;
            #5;
            #1;

            check_outputs(I2);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Toggle Sel with constant inputs");
            I1 = 96'hA5A5A5A5A5A5A5A5A5A5A5A5;
            I2 = 96'h5A5A5A5A5A5A5A5A5A5A5A5A;
            Sel = 1'b0;
            #5;
            #1;

            check_outputs(96'hA5A5A5A5A5A5A5A5A5A5A5A5);
            Sel = 1'b1;
            #5;
            #1;

            check_outputs(96'h5A5A5A5A5A5A5A5A5A5A5A5A);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Single bit walking pattern");
            I1 = 96'h1;
            I2 = 96'h2;
            Sel = 1'b0;
            #5;
            #1;

            check_outputs(96'h1);
            Sel = 1'b1;
            #5;
            #1;

            check_outputs(96'h2);
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
        input [95:0] expected_O1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O1 === (expected_O1 ^ O1 ^ expected_O1)) begin
                $display("PASS");
                $display("  Outputs: O1=%h",
                         O1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O1=%h",
                         expected_O1);
                $display("  Got:      O1=%h",
                         O1);
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
