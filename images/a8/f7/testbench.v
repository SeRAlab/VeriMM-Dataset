`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg [7:0] iDTBUS;
    reg [3:0] iSSFRR;
    reg iWRSFR;
    wire [7:0] oGPO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iDTBUS(iDTBUS),
        .iSSFRR(iSSFRR),
        .iWRSFR(iWRSFR),
        .oGPO(oGPO)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            @(negedge iCLK);
            iDTBUS = 8'h00;
            iSSFRR = 4'b0000;
            iWRSFR = 1'b0;
            @(negedge iCLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write Operation", test_num);
            reset_dut();

            @(negedge iCLK);
            iDTBUS = 8'hA5;
            iSSFRR = 4'b0001;
            iWRSFR = 1'b1;

            @(posedge iCLK);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write with Incorrect iSSFRR", test_num);
            reset_dut();


            @(negedge iCLK);
            iDTBUS = 8'h11;
            iSSFRR = 4'b0001;
            iWRSFR = 1'b1;
            @(posedge iCLK);


            @(negedge iCLK);
            iDTBUS = 8'h22;
            iSSFRR = 4'b0010;
            iWRSFR = 1'b1;
            @(posedge iCLK);

            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write with iWRSFR Low", test_num);
            reset_dut();


            @(negedge iCLK);
            iDTBUS = 8'h33;
            iSSFRR = 4'b0001;
            iWRSFR = 1'b1;
            @(posedge iCLK);


            @(negedge iCLK);
            iDTBUS = 8'h44;
            iSSFRR = 4'b0001;
            iWRSFR = 1'b0;
            @(posedge iCLK);

            #2;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Consecutive Successful Writes", test_num);
            reset_dut();

            @(negedge iCLK);
            iDTBUS = 8'hAA;
            iSSFRR = 4'b0001;
            iWRSFR = 1'b1;
            @(posedge iCLK);

            @(negedge iCLK);
            iDTBUS = 8'h55;
            iSSFRR = 4'b0001;
            iWRSFR = 1'b1;
            @(posedge iCLK);

            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Bus changes without Write Enable", test_num);
            reset_dut();


            @(negedge iCLK);
            iDTBUS = 8'hFF;
            iSSFRR = 4'b0001;
            iWRSFR = 1'b1;
            @(posedge iCLK);


            @(negedge iCLK);
            iDTBUS = 8'h00;
            iSSFRR = 4'b0000;
            iWRSFR = 1'b0;
            @(posedge iCLK);

            #2;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_oGPO;
        begin
            if (expected_oGPO === (expected_oGPO ^ oGPO ^ expected_oGPO)) begin
                $display("PASS");
                $display("  Outputs: oGPO=%h",
                         oGPO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oGPO=%h",
                         expected_oGPO);
                $display("  Got:      oGPO=%h",
                         oGPO);
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
        $dumpvars(0,iCLK, iDTBUS, iSSFRR, iWRSFR, oGPO);
    end

endmodule
