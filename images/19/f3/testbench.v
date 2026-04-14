`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_rx;
    reg start_tx;
    wire [1:0] state;
    wire status;

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
        .state(state),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            reset = 1;
            start_rx = 0;
            start_tx = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset to IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(2'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IDLE to TRANSMIT transition", test_num);
            reset_dut();
            start_tx = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: IDLE to RECEIVE transition", test_num);
            reset_dut();
            start_rx = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd2, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: TRANSMIT back to IDLE", test_num);
            reset_dut();

            start_tx = 1;
            @(posedge clk);
            #1;

            start_tx = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check (TX vs RX)", test_num);
            reset_dut();
            start_tx = 1;
            start_rx = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during RECEIVE state", test_num);
            reset_dut();

            start_rx = 1;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd0, 1'b0);
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
        input expected_status;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: state=%h, status=%b",
                         state, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h, status=%b",
                         expected_state, expected_status);
                $display("  Got:      state=%h, status=%b",
                         state, status);
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
        $dumpvars(0,clk, reset, start_rx, start_tx, state, status);
    end

endmodule
