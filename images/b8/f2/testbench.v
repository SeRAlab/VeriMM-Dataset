`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] iB;
    reg iClk;
    reg iReset_n;
    wire [4:0] oYB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iB(iB),
        .iClk(iClk),
        .iReset_n(iReset_n),
        .oYB(oYB)
    );

    // Clock generation (10ns period)
    initial begin
        iClk = 0;
        forever #5 iClk = ~iClk;
    end

        task reset_dut;

        begin
            iReset_n = 0;
            iB = 8'h00;
            @(posedge iClk);
            #1 iReset_n = 1;
            @(posedge iClk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            iB = 8'h00;
            @(posedge iClk);
            #1 #1;
 check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            iB = 8'hFF;
            @(posedge iClk);
            #1 #1;
 check_outputs(5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            iB = 8'h80;
            @(posedge iClk);
            #1 #1;
 check_outputs(5'h10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            iB = 8'h40;
            @(posedge iClk);
            #1 #1;
 check_outputs(5'h08);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            iB = 8'hE0;
            @(posedge iClk);
            #1 #1;
 check_outputs(5'h1C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            iB = 8'hAA;
            @(posedge iClk);
            #1 #1;
 check_outputs(5'h15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            iB = 8'h55;
            @(posedge iClk);
            #1 #1;
 check_outputs(5'h0A);
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
        input [4:0] expected_oYB;
        begin
            if (expected_oYB === (expected_oYB ^ oYB ^ expected_oYB)) begin
                $display("PASS");
                $display("  Outputs: oYB=%h",
                         oYB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oYB=%h",
                         expected_oYB);
                $display("  Got:      oYB=%h",
                         oYB);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,iB, iClk, iReset_n, oYB);
    end

endmodule
