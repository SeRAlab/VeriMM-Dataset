`timescale 1ns/1ps

module LDO_tb;

    // Testbench signals (combinational circuit)
    reg EN;
    reg [7:0] Vin;
    reg [7:0] Vref;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO dut (
        .EN(EN),
        .Vin(Vin),
        .Vref(Vref),
        .Vout(Vout)
    );
    task testcase001;

        begin
            $display("Running Testcase 001: EN=1, Vin > Vref (Regulation Mode)");
            EN = 1;
            Vin = 8'd150;
            Vref = 8'd100;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: EN=1, Vin < Vref (Dropout Mode)");
            EN = 1;
            Vin = 8'd80;
            Vref = 8'd100;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: EN=1, Vin == Vref (Boundary Mode)");
            EN = 1;
            Vin = 8'd100;
            Vref = 8'd100;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: EN=0, Vin > Vref (Disabled Mode)");
            EN = 0;
            Vin = 8'd150;
            Vref = 8'd100;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: EN=1, Vin=255, Vref=254 (Max Range)");
            EN = 1;
            Vin = 8'hFF;
            Vref = 8'hFE;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: EN=0, Vin < Vref (Disabled Low Input)");
            EN = 0;
            Vin = 8'd20;
            Vref = 8'd50;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: EN=1, Vin > 0, Vref=0");
            EN = 1;
            Vin = 8'd10;
            Vref = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_Vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: Vout=%h",
                         Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%h",
                         expected_Vout);
                $display("  Got:      Vout=%h",
                         Vout);
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
