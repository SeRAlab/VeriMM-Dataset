`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg read_write_same_addr;
    reg ready_o;
    reg reset_i;
    reg scan_not_dq_i;
    reg v_i;
    reg v_r;
    reg yumi_i;
    reg yumi_op_i;
    wire empty;
    wire enque;
    wire rptr_valid;
    wire v_o;
    wire yumi_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .read_write_same_addr(read_write_same_addr),
        .ready_o(ready_o),
        .reset_i(reset_i),
        .scan_not_dq_i(scan_not_dq_i),
        .v_i(v_i),
        .v_r(v_r),
        .yumi_i(yumi_i),
        .yumi_op_i(yumi_op_i),
        .empty(empty),
        .enque(enque),
        .rptr_valid(rptr_valid),
        .v_o(v_o),
        .yumi_o(yumi_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            reset_i = 1;
            v_i = 0;
            yumi_i = 0;
            yumi_op_i = 0;
            ready_o = 0;
            v_r = 0;
            read_write_same_addr = 0;
            scan_not_dq_i = 0;
            @(posedge clk_i);
            #2 reset_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            v_i = 1;
            v_r = 1;
            @(posedge clk_i);


            v_i = 0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            v_i = 1;
            @(posedge clk_i);
            v_i = 0;
            @(posedge clk_i);

            yumi_i = 1;
            @(posedge clk_i);
            yumi_i = 0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            v_i = 1;
            v_r = 1;
            for(i = 0; i < 16; i = i + 1) begin
                @(posedge clk_i);
            end
            v_i = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            v_i = 1;
            @(posedge clk_i);

            v_i = 1;
            yumi_i = 1;
            @(posedge clk_i);
            v_i = 0;
            yumi_i = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
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
        input expected_empty;
        input expected_enque;
        input expected_rptr_valid;
        input expected_v_o;
        input expected_yumi_o;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_enque === (expected_enque ^ enque ^ expected_enque) &&
                expected_rptr_valid === (expected_rptr_valid ^ rptr_valid ^ expected_rptr_valid) &&
                expected_v_o === (expected_v_o ^ v_o ^ expected_v_o) &&
                expected_yumi_o === (expected_yumi_o ^ yumi_o ^ expected_yumi_o)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, enque=%b, rptr_valid=%b, v_o=%b, yumi_o=%b",
                         empty, enque, rptr_valid, v_o, yumi_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, enque=%b, rptr_valid=%b, v_o=%b, yumi_o=%b",
                         expected_empty, expected_enque, expected_rptr_valid, expected_v_o, expected_yumi_o);
                $display("  Got:      empty=%b, enque=%b, rptr_valid=%b, v_o=%b, yumi_o=%b",
                         empty, enque, rptr_valid, v_o, yumi_o);
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
        $dumpvars(0,clk_i, read_write_same_addr, ready_o, reset_i, scan_not_dq_i, v_i, v_r, yumi_i, yumi_op_i, empty, enque, rptr_valid, v_o, yumi_o);
    end

endmodule
