`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [17:0] DI;
    reg EI;
    wire [17:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DI(DI),
        .EI(EI),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLK = 0;
            EI = 0;
            DI = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            DI = 18'd0;
            EI = 1;

            @(posedge CLK);
            #1;

            $display("Testcase %0d: Zero Input", test_num);
            #1;

            check_outputs(18'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            DI = 18'd4;
            EI = 1;

            @(posedge CLK);
            #1;

            $display("Testcase %0d: Standard Processing (Input 4)", test_num);
            #1;

            check_outputs(18'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            DI = 18'd100;
            EI = 1;

            @(posedge CLK);
            #1;

            $display("Testcase %0d: Mid-range value (Input 100)", test_num);
            #1;

            check_outputs(18'd75);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            DI = 18'd100;
            EI = 0;

            @(posedge CLK);
            #1;

            $display("Testcase %0d: Enable Signal Inactive", test_num);

            #1;


            check_outputs(18'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            DI = 18'd4000;
            EI = 1;

            @(posedge CLK);
            #1;

            $display("Testcase %0d: Large Value (Input 4000)", test_num);
            #1;

            check_outputs(18'd3000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            DI = 18'd1024;
            EI = 1;

            @(posedge CLK);
            #1;

            $display("Testcase %0d: Bitwise Shift Logic (Input 1024)", test_num);
            #1;

            check_outputs(18'd768);
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
        input [17:0] expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%h",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h",
                         expected_DO);
                $display("  Got:      DO=%h",
                         DO);
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
        $dumpvars(0,CLK, DI, EI, DO);
    end

endmodule
