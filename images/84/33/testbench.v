`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg iPCJEN;
    reg [7:0] iPCJIN;
    reg iPCRST;
    wire [7:0] oIADDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iPCJEN(iPCJEN),
        .iPCJIN(iPCJIN),
        .iPCRST(iPCRST),
        .oIADDR(oIADDR)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iPCRST = 1;
            iPCJEN = 0;
            iPCJIN = 8'h00;
            @(posedge iCLK);
            #1;
            iPCRST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Increment check (10 cycles)", test_num);
            reset_dut();
            repeat(10) @(posedge iCLK);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Jump load check", test_num);
            reset_dut();
            iPCJEN = 1;
            iPCJIN = 8'hA5;
            @(posedge iCLK);
            #1;
            iPCJEN = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Increment after Jump check", test_num);
            reset_dut();
            iPCJEN = 1;
            iPCJIN = 8'h20;
            @(posedge iCLK);
            iPCJEN = 0;
            repeat(5) @(posedge iCLK);
            #1;
            #1;

            check_outputs(8'h25);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Wrap-around check", test_num);
            reset_dut();
            iPCJEN = 1;
            iPCJIN = 8'hFF;
            @(posedge iCLK);
            iPCJEN = 0;
            @(posedge iCLK);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset priority check", test_num);
            reset_dut();
            iPCJEN = 1;
            iPCJIN = 8'hCC;
            iPCRST = 1;
            @(posedge iCLK);
            #1;
            iPCRST = 0;
            iPCJEN = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Long run check", test_num);
            reset_dut();
            repeat(200) @(posedge iCLK);
            #1;
            #1;

            check_outputs(8'd200);
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
        input [7:0] expected_oIADDR;
        begin
            if (expected_oIADDR === (expected_oIADDR ^ oIADDR ^ expected_oIADDR)) begin
                $display("PASS");
                $display("  Outputs: oIADDR=%h",
                         oIADDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oIADDR=%h",
                         expected_oIADDR);
                $display("  Got:      oIADDR=%h",
                         oIADDR);
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
        $dumpvars(0,iCLK, iPCJEN, iPCJIN, iPCRST, oIADDR);
    end

endmodule
