`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DATA;
    reg INT_FLAG_RESETn;
    reg RESETn;
    wire INT_FLAG;
    wire LAST_CLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA(DATA),
        .INT_FLAG_RESETn(INT_FLAG_RESETn),
        .RESETn(RESETn),
        .INT_FLAG(INT_FLAG),
        .LAST_CLK(LAST_CLK)
    );

    // Clock generation (10ns period)
    initial begin
        DATA = 0;
        forever #5 DATA = ~DATA;
    end

        task reset_dut;

        begin
            RESETn = 0;
            INT_FLAG_RESETn = 1;
            CLK = 0;
            #12;
            RESETn = 1;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Capture CLK=0", test_num);
            reset_dut();
            CLK = 0;
            @(posedge DATA);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Capture CLK=1 and Set Interrupt", test_num);
            reset_dut();
            CLK = 1;
            @(posedge DATA);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Reset Interrupt Flag", test_num);
            reset_dut();
            CLK = 1;
            @(posedge DATA);
            #2;

            INT_FLAG_RESETn = 0;
            #10;
            INT_FLAG_RESETn = 1;
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Interrupt Persistence", test_num);
            reset_dut();
            CLK = 1;
            @(posedge DATA);
            #2;
            CLK = 0;
            @(posedge DATA);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Async System Reset Priority", test_num);
            reset_dut();
            CLK = 1;
            @(posedge DATA);
            #2;
            RESETn = 0;
            #5;
            #1;

            check_outputs(0, 0);
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
        input expected_INT_FLAG;
        input expected_LAST_CLK;
        begin
            if (expected_INT_FLAG === (expected_INT_FLAG ^ INT_FLAG ^ expected_INT_FLAG) &&
                expected_LAST_CLK === (expected_LAST_CLK ^ LAST_CLK ^ expected_LAST_CLK)) begin
                $display("PASS");
                $display("  Outputs: INT_FLAG=%b, LAST_CLK=%b",
                         INT_FLAG, LAST_CLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: INT_FLAG=%b, LAST_CLK=%b",
                         expected_INT_FLAG, expected_LAST_CLK);
                $display("  Got:      INT_FLAG=%b, LAST_CLK=%b",
                         INT_FLAG, LAST_CLK);
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
        $dumpvars(0,CLK, DATA, INT_FLAG_RESETn, RESETn, INT_FLAG, LAST_CLK);
    end

endmodule
