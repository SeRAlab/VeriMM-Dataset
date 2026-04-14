`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg WF_dispatch_i;
    reg fetch_valid;
    wire inst_buff_rd;
    wire wave_reserve_valid;
    wire wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WF_dispatch_i(WF_dispatch_i),
        .fetch_valid(fetch_valid),
        .inst_buff_rd(inst_buff_rd),
        .wave_reserve_valid(wave_reserve_valid),
        .wr(wr)
    );
    task testcase001;

    begin
        $display("Testcase 001: WF_dispatch_i=0, fetch_valid=0");
        WF_dispatch_i = 1'b0;
        fetch_valid   = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: WF_dispatch_i=1, fetch_valid=0");
        WF_dispatch_i = 1'b1;
        fetch_valid   = 1'b0;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: WF_dispatch_i=0, fetch_valid=1");
        WF_dispatch_i = 1'b0;
        fetch_valid   = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: WF_dispatch_i=1, fetch_valid=1");
        WF_dispatch_i = 1'b1;
        fetch_valid   = 1'b1;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Rapid sequence of inputs");

        WF_dispatch_i = 1'b1;
        fetch_valid   = 1'b1;
        #10;

        WF_dispatch_i = 1'b0;
        fetch_valid   = 1'b0;
        #10;

        WF_dispatch_i = 1'b1;
        fetch_valid   = 1'b0;
        #10;


        WF_dispatch_i = 1'b0;
        fetch_valid   = 1'b1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b0);
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
        input expected_inst_buff_rd;
        input expected_wave_reserve_valid;
        input expected_wr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inst_buff_rd === (expected_inst_buff_rd ^ inst_buff_rd ^ expected_inst_buff_rd) &&
                expected_wave_reserve_valid === (expected_wave_reserve_valid ^ wave_reserve_valid ^ expected_wave_reserve_valid) &&
                expected_wr === (expected_wr ^ wr ^ expected_wr)) begin
                $display("PASS");
                $display("  Outputs: inst_buff_rd=%b, wave_reserve_valid=%b, wr=%b",
                         inst_buff_rd, wave_reserve_valid, wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inst_buff_rd=%b, wave_reserve_valid=%b, wr=%b",
                         expected_inst_buff_rd, expected_wave_reserve_valid, expected_wr);
                $display("  Got:      inst_buff_rd=%b, wave_reserve_valid=%b, wr=%b",
                         inst_buff_rd, wave_reserve_valid, wr);
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
