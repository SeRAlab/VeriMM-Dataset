`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] RX_STATUS;
    reg USER_CLK;
    wire CHANNEL_BOND_LOAD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RX_STATUS(RX_STATUS),
        .USER_CLK(USER_CLK),
        .CHANNEL_BOND_LOAD(CHANNEL_BOND_LOAD)
    );

    // Clock generation (10ns period)
    initial begin
        USER_CLK = 0;
        forever #5 USER_CLK = ~USER_CLK;
    end

        task reset_dut;

        begin
            RX_STATUS = 6'b0;
            @(posedge USER_CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Idle state (RX_STATUS=0)", test_num);
            RX_STATUS = 6'b000_000;
            repeat(2) @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Trigger Load (RX_STATUS[5:3]=3'b100)", test_num);
            RX_STATUS = 6'b100_000;
            repeat(2) @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Non-trigger status (RX_STATUS[5:3]=3'b001)", test_num);
            RX_STATUS = 6'b001_000;
            repeat(2) @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Trigger with extra bits (RX_STATUS=6'b100111)", test_num);
            RX_STATUS = 6'b100_111;
            repeat(2) @(posedge USER_CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Transition from Trigger to Idle", test_num);


            RX_STATUS = 6'b100_000;
            @(posedge USER_CLK);
            #1;


            RX_STATUS = 6'b000_000;
            repeat(2) @(posedge USER_CLK);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Full status bits (RX_STATUS=6'b111111)", test_num);
            RX_STATUS = 6'b111_111;
            repeat(2) @(posedge USER_CLK);
            #1;

            #1;


            check_outputs(1'b0);
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
        input expected_CHANNEL_BOND_LOAD;
        begin
            if (expected_CHANNEL_BOND_LOAD === (expected_CHANNEL_BOND_LOAD ^ CHANNEL_BOND_LOAD ^ expected_CHANNEL_BOND_LOAD)) begin
                $display("PASS");
                $display("  Outputs: CHANNEL_BOND_LOAD=%b",
                         CHANNEL_BOND_LOAD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CHANNEL_BOND_LOAD=%b",
                         expected_CHANNEL_BOND_LOAD);
                $display("  Got:      CHANNEL_BOND_LOAD=%b",
                         CHANNEL_BOND_LOAD);
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
        $dumpvars(0,RX_STATUS, USER_CLK, CHANNEL_BOND_LOAD);
    end

endmodule
