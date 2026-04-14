`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg sel;
    wire [7:0] m_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .m_out(m_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select in0 (8'hA5)");
            in0 = 8'hA5;
            in1 = 8'h5A;
            sel = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select in1 (8'h5A)");
            in0 = 8'hA5;
            in1 = 8'h5A;
            sel = 1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select in0 with all bits high (8'hFF)");
            in0 = 8'hFF;
            in1 = 8'h00;
            sel = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select in1 with all bits high (8'hFF)");
            in0 = 8'h00;
            in1 = 8'hFF;
            sel = 1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select in0 with all bits low (8'h00)");
            in0 = 8'h00;
            in1 = 8'hFF;
            sel = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select in1 with all bits low (8'h00)");
            in0 = 8'hFF;
            in1 = 8'h00;
            sel = 1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Select in0 with alternating bits (8'hAA)");
            in0 = 8'hAA;
            in1 = 8'h55;
            sel = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Select in1 with alternating bits (8'h55)");
            in0 = 8'hAA;
            in1 = 8'h55;
            sel = 1;
            #1;

            check_outputs(8'h55);
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
        input [7:0] expected_m_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m_out === (expected_m_out ^ m_out ^ expected_m_out)) begin
                $display("PASS");
                $display("  Outputs: m_out=%h",
                         m_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_out=%h",
                         expected_m_out);
                $display("  Got:      m_out=%h",
                         m_out);
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
