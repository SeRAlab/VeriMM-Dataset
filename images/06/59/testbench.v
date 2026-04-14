`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pkt_done;
    reg pkt_rx;
    reg pkt_tx;
    reg rst;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .pkt_done(pkt_done),
        .pkt_rx(pkt_rx),
        .pkt_tx(pkt_tx),
        .rst(rst),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pkt_done = 0;
            pkt_rx = 0;
            pkt_tx = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check IDLE state after reset", test_num);
            reset_dut();
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: IDLE -> RECEIVE transition", test_num);
            reset_dut();
            pkt_rx = 1;
            @(posedge clk);
            #1;
            pkt_rx = 0;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: RECEIVE -> IDLE transition", test_num);
            reset_dut();

            pkt_rx = 1;
            @(posedge clk);
            #1 pkt_rx = 0;

            pkt_done = 1;
            @(posedge clk);
            #1 pkt_done = 0;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: RECEIVE -> TRANSMIT transition", test_num);
            reset_dut();

            pkt_rx = 1;
            @(posedge clk);
            #1 pkt_rx = 0;

            pkt_tx = 1;
            @(posedge clk);
            #1 pkt_tx = 0;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: TRANSMIT -> IDLE transition", test_num);
            reset_dut();

            pkt_rx = 1;
            @(posedge clk);
            #1 pkt_rx = 0;

            pkt_tx = 1;
            @(posedge clk);
            #1 pkt_tx = 0;

            pkt_done = 1;
            @(posedge clk);
            #1 pkt_done = 0;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: IDLE with pkt_tx (should stay IDLE)", test_num);
            reset_dut();
            pkt_tx = 1;
            @(posedge clk);
            #1 pkt_tx = 0;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Stay in RECEIVE when idle", test_num);
            reset_dut();
            pkt_rx = 1;
            @(posedge clk);
            #1 pkt_rx = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Stay in TRANSMIT when idle", test_num);
            reset_dut();
            pkt_rx = 1;
            @(posedge clk);
            #1 pkt_rx = 0;
            pkt_tx = 1;
            @(posedge clk);
            #1 pkt_tx = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, pkt_done, pkt_rx, pkt_tx, rst, state);
    end

endmodule
