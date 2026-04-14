`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BC_RELEASE_ISO;
    reg CLKIN;
    reg MBUS_CLR_BUSY;
    reg RESETn;
    reg SC_CLR_BUSY;
    wire BUS_BUSYn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BC_RELEASE_ISO(BC_RELEASE_ISO),
        .CLKIN(CLKIN),
        .MBUS_CLR_BUSY(MBUS_CLR_BUSY),
        .RESETn(RESETn),
        .SC_CLR_BUSY(SC_CLR_BUSY),
        .BUS_BUSYn(BUS_BUSYn)
    );

    // Clock generation (10ns period)
    initial begin
        CLKIN = 0;
        forever #5 CLKIN = ~CLKIN;
    end

        task reset_dut;

        begin
            RESETn = 0;
            BC_RELEASE_ISO = 0;
            SC_CLR_BUSY = 0;
            MBUS_CLR_BUSY = 0;
            @(negedge CLKIN);
            #1;
            RESETn = 1;
            @(negedge CLKIN);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Active Reset behavior", test_num);
            RESETn = 0;
            BC_RELEASE_ISO = 0;
            SC_CLR_BUSY = 0;
            MBUS_CLR_BUSY = 0;
            @(negedge CLKIN);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle state (no clears/resets)", test_num);
            reset_dut();
            RESETn = 1;
            BC_RELEASE_ISO = 0;
            SC_CLR_BUSY = 0;
            MBUS_CLR_BUSY = 0;
            @(negedge CLKIN);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: BC_RELEASE_ISO clear", test_num);
            reset_dut();
            BC_RELEASE_ISO = 1;
            @(negedge CLKIN);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SC_CLR_BUSY clear", test_num);
            reset_dut();
            SC_CLR_BUSY = 1;
            @(negedge CLKIN);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: MBUS_CLR_BUSY clear", test_num);
            reset_dut();
            MBUS_CLR_BUSY = 1;
            @(negedge CLKIN);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple clear signals active", test_num);
            reset_dut();
            SC_CLR_BUSY = 1;
            MBUS_CLR_BUSY = 1;
            @(negedge CLKIN);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Timing check (Falling edge synchronization)", test_num);
            reset_dut();
            @(negedge CLKIN);
            #1;
            BC_RELEASE_ISO = 1;
            #1;

            #1;


            check_outputs(1'b1);
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
        input expected_BUS_BUSYn;
        begin
            if (expected_BUS_BUSYn === (expected_BUS_BUSYn ^ BUS_BUSYn ^ expected_BUS_BUSYn)) begin
                $display("PASS");
                $display("  Outputs: BUS_BUSYn=%b",
                         BUS_BUSYn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BUS_BUSYn=%b",
                         expected_BUS_BUSYn);
                $display("  Got:      BUS_BUSYn=%b",
                         BUS_BUSYn);
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
        $dumpvars(0,BC_RELEASE_ISO, CLKIN, MBUS_CLR_BUSY, RESETn, SC_CLR_BUSY, BUS_BUSYn);
    end

endmodule
