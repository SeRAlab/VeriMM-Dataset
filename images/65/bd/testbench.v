`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg [15:0] iData;
    reg iRST;
    wire [15:0] oEncData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iData(iData),
        .iRST(iRST),
        .oEncData(oEncData)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iRST = 1;
            iData = 16'h0000;
            @(posedge iCLK);
            #1 iRST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            iRST = 1;
            iData = 16'hFFFF;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(16'h0000);
            iRST = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            iData = 16'h0000;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            iData = 16'h0102;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(16'h010B);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            iData = 16'hFF00;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(16'hFDFD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            iData = 16'h00FF;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(16'h0202);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            iData = 16'h8080;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(16'h8080);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            iData = 16'h1234;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(16'h1246);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            iData = 16'hFFFF;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_oEncData;
        begin
            if (expected_oEncData === (expected_oEncData ^ oEncData ^ expected_oEncData)) begin
                $display("PASS");
                $display("  Outputs: oEncData=%h",
                         oEncData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oEncData=%h",
                         expected_oEncData);
                $display("  Got:      oEncData=%h",
                         oEncData);
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
        $dumpvars(0,iCLK, iData, iRST, oEncData);
    end

endmodule
