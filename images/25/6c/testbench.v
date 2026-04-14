`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_valid;
    reg reset;
    reg rx_done;
    reg start_tx;
    wire rx_enable;
    wire [1:0] state;
    wire tx_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_valid(data_valid),
        .reset(reset),
        .rx_done(rx_done),
        .start_tx(start_tx),
        .rx_enable(rx_enable),
        .state(state),
        .tx_enable(tx_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_valid = 0;
            rx_done = 0;
            start_tx = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial IDLE state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Transition IDLE -> RECEIVE", test_num);
            reset_dut();
            data_valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b01, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Transition IDLE -> TRANSMIT", test_num);
            reset_dut();
            start_tx = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Full Receive Cycle (RECEIVE -> IDLE)", test_num);
            reset_dut();
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;
            rx_done = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Full Transmit Cycle (TRANSMIT -> IDLE)", test_num);
            reset_dut();
            start_tx = 1;
            @(posedge clk);
            #1;
            start_tx = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Priority Check (RX vs TX)", test_num);
            reset_dut();
            data_valid = 1;
            start_tx = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b01, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Ignore TX during RECEIVE", test_num);
            reset_dut();
            data_valid = 1;
            @(posedge clk);
            #1;
            start_tx = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b01, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: TRANSMIT to IDLE then RECEIVE", test_num);
            reset_dut();
            start_tx = 1;
            @(posedge clk);
            #1;
            start_tx = 0;
            data_valid = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b01, 1'b0);
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
        input expected_rx_enable;
        input [1:0] expected_state;
        input expected_tx_enable;
        begin
            if (expected_rx_enable === (expected_rx_enable ^ rx_enable ^ expected_rx_enable) &&
                expected_state === (expected_state ^ state ^ expected_state) &&
                expected_tx_enable === (expected_tx_enable ^ tx_enable ^ expected_tx_enable)) begin
                $display("PASS");
                $display("  Outputs: rx_enable=%b, state=%h, tx_enable=%b",
                         rx_enable, state, tx_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_enable=%b, state=%h, tx_enable=%b",
                         expected_rx_enable, expected_state, expected_tx_enable);
                $display("  Got:      rx_enable=%b, state=%h, tx_enable=%b",
                         rx_enable, state, tx_enable);
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
        $dumpvars(0,clk, data_valid, reset, rx_done, start_tx, rx_enable, state, tx_enable);
    end

endmodule
