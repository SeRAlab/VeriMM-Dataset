`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg merge_node_valid_in_0_staging_reg;
    reg merge_node_valid_in_1_staging_reg;
    reg merge_stalled_by_successors;
    reg resetn;
    reg valid_in_0;
    reg valid_in_1;
    reg [9:0] workgroup_size;
    wire is_merge_data_to_local_regs_valid;
    wire merge_block_selector;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .merge_node_valid_in_0_staging_reg(merge_node_valid_in_0_staging_reg),
        .merge_node_valid_in_1_staging_reg(merge_node_valid_in_1_staging_reg),
        .merge_stalled_by_successors(merge_stalled_by_successors),
        .resetn(resetn),
        .valid_in_0(valid_in_0),
        .valid_in_1(valid_in_1),
        .workgroup_size(workgroup_size),
        .is_merge_data_to_local_regs_valid(is_merge_data_to_local_regs_valid),
        .merge_block_selector(merge_block_selector)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        resetn = 0;
        merge_node_valid_in_0_staging_reg = 0;
        merge_node_valid_in_1_staging_reg = 0;
        merge_stalled_by_successors = 0;
        valid_in_0 = 0;
        valid_in_1 = 0;
        workgroup_size = 10'd64;
        @(posedge clock);
        #1 resetn = 1;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        valid_in_0 = 0;
        valid_in_1 = 0;
        merge_node_valid_in_0_staging_reg = 0;
        merge_node_valid_in_1_staging_reg = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        valid_in_0 = 1;
        valid_in_1 = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        valid_in_0 = 0;
        valid_in_1 = 1;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        valid_in_0 = 1;
        valid_in_1 = 1;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        merge_node_valid_in_0_staging_reg = 1;
        valid_in_0 = 0;
        valid_in_1 = 1;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        merge_node_valid_in_0_staging_reg = 0;
        merge_node_valid_in_1_staging_reg = 1;
        valid_in_0 = 0;
        valid_in_1 = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        valid_in_0 = 1;
        merge_stalled_by_successors = 1;
        @(posedge clock);
        #1;


        #1;



        check_outputs(0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        workgroup_size = 10'd128;
        valid_in_0 = 0;
        valid_in_1 = 1;
        merge_node_valid_in_1_staging_reg = 1;
        merge_stalled_by_successors = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1, 1);
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
        input expected_is_merge_data_to_local_regs_valid;
        input expected_merge_block_selector;
        begin
            if (expected_is_merge_data_to_local_regs_valid === (expected_is_merge_data_to_local_regs_valid ^ is_merge_data_to_local_regs_valid ^ expected_is_merge_data_to_local_regs_valid) &&
                expected_merge_block_selector === (expected_merge_block_selector ^ merge_block_selector ^ expected_merge_block_selector)) begin
                $display("PASS");
                $display("  Outputs: is_merge_data_to_local_regs_valid=%b, merge_block_selector=%b",
                         is_merge_data_to_local_regs_valid, merge_block_selector);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_merge_data_to_local_regs_valid=%b, merge_block_selector=%b",
                         expected_is_merge_data_to_local_regs_valid, expected_merge_block_selector);
                $display("  Got:      is_merge_data_to_local_regs_valid=%b, merge_block_selector=%b",
                         is_merge_data_to_local_regs_valid, merge_block_selector);
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
        $dumpvars(0,clock, merge_node_valid_in_0_staging_reg, merge_node_valid_in_1_staging_reg, merge_stalled_by_successors, resetn, valid_in_0, valid_in_1, workgroup_size, is_merge_data_to_local_regs_valid, merge_block_selector);
    end

endmodule
