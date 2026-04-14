`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg [7:0] iMULHB;
    reg iWRMLR;
    wire [7:0] oMULRG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iMULHB(iMULHB),
        .iWRMLR(iWRMLR),
        .oMULRG(oMULRG)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iWRMLR = 0;
            iMULHB = 8'h00;
            @(posedge iCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Basic Write 0xA5", test_num);
            iWRMLR = 1;
            iMULHB = 8'hA5;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Write Disable (Hold Logic)", test_num);

            iWRMLR = 1;
            iMULHB = 8'h55;
            @(posedge iCLK);
            #1;

            iWRMLR = 0;
            iMULHB = 8'hAA;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Successive Writes", test_num);
            iWRMLR = 1;
            iMULHB = 8'h11;
            @(posedge iCLK);
            #1;
            iMULHB = 8'h22;
            @(posedge iCLK);
            #1;
            iMULHB = 8'h33;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Boundary Values (0x00 and 0xFF)", test_num);

            iWRMLR = 1;
            iMULHB = 8'hFF;
            @(posedge iCLK);
            #1;
            if (oMULRG !== 8'hFF) begin
                #1;

                check_outputs(8'hFF);
            end else begin

                iMULHB = 8'h00;
                @(posedge iCLK);
                #1;
                #1;

                check_outputs(8'h00);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Walking Bit Pattern", test_num);
            iWRMLR = 1;
            iMULHB = 8'h01; @(posedge iCLK); #1;
            iMULHB = 8'h02; @(posedge iCLK); #1;
            iMULHB = 8'h04; @(posedge iCLK); #1;
            iMULHB = 8'h08; @(posedge iCLK); #1;
            iMULHB = 8'h10; @(posedge iCLK); #1;
            iMULHB = 8'h20; @(posedge iCLK); #1;
            iMULHB = 8'h40; @(posedge iCLK); #1;
            iMULHB = 8'h80; @(posedge iCLK); #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Toggle Write Enable", test_num);

            iWRMLR = 1;
            iMULHB = 8'hCC;
            @(posedge iCLK);
            #1;

            iWRMLR = 0;
            iMULHB = 8'hDD;
            @(posedge iCLK);
            #1;

            iWRMLR = 1;
            iMULHB = 8'hEE;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(8'hEE);
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
        input [7:0] expected_oMULRG;
        begin
            if (expected_oMULRG === (expected_oMULRG ^ oMULRG ^ expected_oMULRG)) begin
                $display("PASS");
                $display("  Outputs: oMULRG=%h",
                         oMULRG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oMULRG=%h",
                         expected_oMULRG);
                $display("  Got:      oMULRG=%h",
                         oMULRG);
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
        $dumpvars(0,iCLK, iMULHB, iWRMLR, oMULRG);
    end

endmodule
