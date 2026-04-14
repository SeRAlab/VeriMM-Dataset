`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg aclr;
    reg datain;
    reg latch_enable;
    reg preset;
    wire dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclr(aclr),
        .datain(datain),
        .latch_enable(latch_enable),
        .preset(preset),
        .dataout(dataout)
    );
    task testcase001;

        begin
            $display("Testcase 001: Asynchronous Clear");
            aclr = 1; preset = 0; latch_enable = 0; datain = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Asynchronous Preset");
            aclr = 1; #10;
            aclr = 0; preset = 1; latch_enable = 0; datain = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Clear Priority over Preset");
            aclr = 1; preset = 1; latch_enable = 1; datain = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Latch Transparency (Data 1)");
            aclr = 1; #10;
            aclr = 0; preset = 0; latch_enable = 1; datain = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Latch Transparency (Data 0)");
            aclr = 1; #10;
            aclr = 0; preset = 0; latch_enable = 1; datain = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Latch Hold (Holding 1)");
            aclr = 1; #10;
            aclr = 0; preset = 0; latch_enable = 1; datain = 1; #10;
            latch_enable = 0; datain = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Latch Hold (Holding 0)");
            aclr = 1; #10;
            aclr = 0; preset = 0; latch_enable = 0; datain = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Asynchronous Preset Overriding Latch");
            aclr = 1; #10;
            aclr = 0; latch_enable = 1; datain = 0; #10;
            preset = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Asynchronous Clear Overriding Latch and Preset");
            aclr = 1; #10;
            aclr = 0; preset = 1; latch_enable = 1; datain = 1; #10;
            aclr = 1;
            #10;
            #1;

            check_outputs(1'b0);
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
        input expected_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%b",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%b",
                         expected_dataout);
                $display("  Got:      dataout=%b",
                         dataout);
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
