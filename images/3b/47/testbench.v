`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start_rx;
    reg start_tx;
    wire rx_active;
    wire [1:0] state;
    wire tx_active;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .rst(rst),
        .start_rx(start_rx),
        .start_tx(start_tx),
        .rx_active(rx_active),
        .state(state),
        .tx_active(tx_active)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start_rx = 0;
            start_tx = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Power-on Reset to IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transition IDLE to TRANSMIT", test_num);
            reset_dut();
            start_tx = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transition IDLE to RECEIVE", test_num);
            reset_dut();
            start_rx = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: TRANSMIT to IDLE return", test_num);
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

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: RECEIVE to IDLE return", test_num);
            reset_dut();
            start_rx = 1;
            @(posedge clk);
            #1;
            start_rx = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Simultaneous TX/RX request (TX Priority)", test_num);
            reset_dut();
            start_tx = 1;
            start_rx = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 2'b01, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Reset during TRANSMIT", test_num);
            reset_dut();
            start_tx = 1;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b00, 1'b0);
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
        input expected_rx_active;
        input [1:0] expected_state;
        input expected_tx_active;
        begin
            if (expected_rx_active === (expected_rx_active ^ rx_active ^ expected_rx_active) &&
                expected_state === (expected_state ^ state ^ expected_state) &&
                expected_tx_active === (expected_tx_active ^ tx_active ^ expected_tx_active)) begin
                $display("PASS");
                $display("  Outputs: rx_active=%b, state=%h, tx_active=%b",
                         rx_active, state, tx_active);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_active=%b, state=%h, tx_active=%b",
                         expected_rx_active, expected_state, expected_tx_active);
                $display("  Got:      rx_active=%b, state=%h, tx_active=%b",
                         rx_active, state, tx_active);
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
        $dumpvars(0,clk, rst, start_rx, start_tx, rx_active, state, tx_active);
    end

endmodule
