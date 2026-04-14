`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg receive_data;
    reg rst;
    reg start_transmit;
    wire receive_enable;
    wire [1:0] state;
    wire transmit_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .receive_data(receive_data),
        .rst(rst),
        .start_transmit(start_transmit),
        .receive_enable(receive_enable),
        .state(state),
        .transmit_enable(transmit_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start_transmit = 0;
            receive_data = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Post-Reset Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(0, STATE_IDLE, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transition to TRANSMIT", test_num);
            reset_dut();
            @(posedge clk);
            start_transmit = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, STATE_TRANSMIT, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transition to RECEIVE", test_num);
            reset_dut();
            @(posedge clk);
            receive_data = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1, STATE_RECEIVE, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Priority Check (Both start signals)", test_num);
            reset_dut();
            @(posedge clk);
            start_transmit = 1;
            receive_data = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(0, STATE_TRANSMIT, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: TRANSMIT to IDLE transition", test_num);
            reset_dut();
            @(posedge clk);
            start_transmit = 1;
            @(posedge clk);
            #2 start_transmit = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, STATE_IDLE, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: RECEIVE to IDLE transition", test_num);
            reset_dut();
            @(posedge clk);
            receive_data = 1;
            @(posedge clk);
            #2 receive_data = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, STATE_IDLE, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Stability in IDLE", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            check_outputs(0, STATE_IDLE, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input expected_receive_enable;
        input [1:0] expected_state;
        input expected_transmit_enable;
        begin
            if (expected_receive_enable === (expected_receive_enable ^ receive_enable ^ expected_receive_enable) &&
                expected_state === (expected_state ^ state ^ expected_state) &&
                expected_transmit_enable === (expected_transmit_enable ^ transmit_enable ^ expected_transmit_enable)) begin
                $display("PASS");
                $display("  Outputs: receive_enable=%b, state=%h, transmit_enable=%b",
                         receive_enable, state, transmit_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: receive_enable=%b, state=%h, transmit_enable=%b",
                         expected_receive_enable, expected_state, expected_transmit_enable);
                $display("  Got:      receive_enable=%b, state=%h, transmit_enable=%b",
                         receive_enable, state, transmit_enable);
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
        $dumpvars(0,clk, receive_data, rst, start_transmit, receive_enable, state, transmit_enable);
    end

endmodule
