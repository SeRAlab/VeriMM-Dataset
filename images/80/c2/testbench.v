`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] indata;
    reg [1:0] sel;
    wire [7:0] outdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .indata(indata),
        .sel(sel),
        .outdata(outdata)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select index 0 (LSB)");
            indata = 32'hAABBCCDD;
            sel = 2'd0;
            #1;

            check_outputs(8'hDD);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select index 1");
            indata = 32'hAABBCCDD;
            sel = 2'd1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select index 2");
            indata = 32'hAABBCCDD;
            sel = 2'd2;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select index 3 (MSB)");
            indata = 32'hAABBCCDD;
            sel = 2'd3;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All ones input, index 0");
            indata = 32'hFFFFFFFF;
            sel = 2'd0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All zeros input, index 3");
            indata = 32'h00000000;
            sel = 2'd3;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Alternating bits pattern 1, index 1");
            indata = 32'h55AA55AA;
            sel = 2'd1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Alternating bits pattern 2, index 2");
            indata = 32'h55AA55AA;
            sel = 2'd2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Walking bit pattern, index 0");
            indata = 32'h00000001;
            sel = 2'd0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Hex pattern DEAD BEEF, index 1");
            indata = 32'hDEADBEEF;
            sel = 2'd1;
            #1;

            check_outputs(8'hBE);
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
        input [7:0] expected_outdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outdata === (expected_outdata ^ outdata ^ expected_outdata)) begin
                $display("PASS");
                $display("  Outputs: outdata=%h",
                         outdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outdata=%h",
                         expected_outdata);
                $display("  Got:      outdata=%h",
                         outdata);
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
