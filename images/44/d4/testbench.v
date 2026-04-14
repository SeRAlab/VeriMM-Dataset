`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cmd;
    reg cmd_ack;
    reg reset;
    wire cmd_buffer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cmd(cmd),
        .cmd_ack(cmd_ack),
        .reset(reset),
        .cmd_buffer(cmd_buffer)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cmd = 0;
            cmd_ack = 0;
            #10;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial IDLE State Check", test_num);
            reset_dut();

            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IDLE to VALID Transition", test_num);
            reset_dut();
            cmd = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: VALID State Retention (cmd_ack=0)", test_num);
            reset_dut();
            cmd = 1;
            @(posedge clk);
            cmd_ack = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: VALID to WAIT Transition", test_num);
            reset_dut();
            cmd = 1;
            @(posedge clk);
            cmd_ack = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: WAIT State Retention (cmd=1)", test_num);
            reset_dut();
            cmd = 1;
            @(posedge clk);
            cmd_ack = 1;
            @(posedge clk);
            cmd = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: WAIT to IDLE Transition", test_num);
            reset_dut();
            cmd = 1;
            @(posedge clk);
            cmd_ack = 1;
            @(posedge clk);
            cmd = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Mid-Sequence (VALID -> Reset)", test_num);
            reset_dut();
            cmd = 1;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;
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
        input expected_cmd_buffer;
        begin
            if (expected_cmd_buffer === (expected_cmd_buffer ^ cmd_buffer ^ expected_cmd_buffer)) begin
                $display("PASS");
                $display("  Outputs: cmd_buffer=%b",
                         cmd_buffer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cmd_buffer=%b",
                         expected_cmd_buffer);
                $display("  Got:      cmd_buffer=%b",
                         cmd_buffer);
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
        $dumpvars(0,clk, cmd, cmd_ack, reset, cmd_buffer);
    end

endmodule
