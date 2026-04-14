`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] config_data;
    reg finish_now;
    reg wrFlags;
    wire [31:0] flags_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .config_data(config_data),
        .finish_now(finish_now),
        .wrFlags(wrFlags),
        .flags_reg(flags_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            wrFlags = 1;
            config_data = 32'h0;
            finish_now = 0;
            @(negedge clock);
            wrFlags = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write All Ones", test_num);
            reset_dut();

            @(negedge clock);
            wrFlags = 1;
            config_data = 32'hFFFFFFFF;
            finish_now = 0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Retention", test_num);
            reset_dut();


            @(negedge clock);
            wrFlags = 1;
            config_data = 32'h12345678;
            @(posedge clock);


            @(negedge clock);
            wrFlags = 0;
            config_data = 32'h87654321;

            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: finish_now clears bit 8", test_num);
            reset_dut();


            @(negedge clock);
            wrFlags = 1;
            config_data = 32'h00000100;
            @(posedge clock);


            @(negedge clock);
            wrFlags = 0;
            finish_now = 1;

            @(posedge clock);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Concurrent Write and finish_now", test_num);
            reset_dut();


            @(negedge clock);
            wrFlags = 1;
            config_data = 32'hFFFFFFFF;
            finish_now = 1;

            @(posedge clock);
            #1;

            #1;


            check_outputs(32'hFFFFFEFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Data Write and clear", test_num);
            reset_dut();

            @(negedge clock);
            wrFlags = 1;
            config_data = 32'hABCDFFFF;
            finish_now = 0;
            @(posedge clock);

            @(negedge clock);
            wrFlags = 0;
            finish_now = 1;
            @(posedge clock);

            #1;

            #1;


            check_outputs(32'hABCDFEFF);
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
        input [31:0] expected_flags_reg;
        begin
            if (expected_flags_reg === (expected_flags_reg ^ flags_reg ^ expected_flags_reg)) begin
                $display("PASS");
                $display("  Outputs: flags_reg=%h",
                         flags_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flags_reg=%h",
                         expected_flags_reg);
                $display("  Got:      flags_reg=%h",
                         flags_reg);
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
        $dumpvars(0,clock, config_data, finish_now, wrFlags, flags_reg);
    end

endmodule
