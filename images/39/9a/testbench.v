`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_rx;
    reg start_tx;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .reset(reset),
        .start_rx(start_rx),
        .start_tx(start_tx),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_rx = 0;
            start_tx = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Verification of IDLE state after reset");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Transition IDLE -> TRANSMIT");
            test_num = 2;
            reset_dut();
            @(negedge clk);
            start_tx = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Return to IDLE from TRANSMIT");
            test_num = 3;
            reset_dut();
            @(negedge clk);
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Transition IDLE -> RECEIVE");
            test_num = 4;
            reset_dut();
            @(negedge clk);
            start_rx = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Return to IDLE from RECEIVE");
            test_num = 5;
            reset_dut();
            @(negedge clk);
            start_rx = 1;
            @(posedge clk);
            start_rx = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Simultaneous TX and RX request");
            test_num = 6;
            reset_dut();
            @(negedge clk);
            start_tx = 1;
            start_rx = 1;
            @(posedge clk);
            #1;


            if (state == 2'b01 || state == 2'b10) begin
                $display("Priority handled. State: %b", state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAILED: No state transition on simultaneous signals");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset during TRANSMIT");
            test_num = 7;
            reset_dut();
            @(negedge clk);
            start_tx = 1;
            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
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
        $dumpvars(0,clk, reset, start_rx, start_tx, state);
    end

endmodule
