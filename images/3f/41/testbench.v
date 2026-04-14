`timescale 1ns/1ps

module pcie_sm_tb;

    // Testbench signals (sequential circuit)
    reg ack_txn;
    reg clk;
    reg reset;
    reg valid_txn;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_sm dut (
        .ack_txn(ack_txn),
        .clk(clk),
        .reset(reset),
        .valid_txn(valid_txn),
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
            valid_txn = 0;
            ack_txn = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset to IDLE", test_num);
            reset_dut();
            #1;

            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: IDLE to REQUEST transition", test_num);
            reset_dut();
            @(negedge clk);
            valid_txn = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_REQUEST);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: IDLE to REQUEST to ACKNOWLEDGE transition", test_num);
            reset_dut();
            @(negedge clk);
            valid_txn = 1;
            @(posedge clk);
            #1;
            valid_txn = 0;
            ack_txn = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_ACKNOWLEDGE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Full cycle back to IDLE", test_num);
            reset_dut();
            @(negedge clk);
            valid_txn = 1;
            @(posedge clk);
            @(negedge clk);
            ack_txn = 1;
            @(posedge clk);
            @(negedge clk);
            ack_txn = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Stay in REQUEST state while ack is low", test_num);
            reset_dut();
            @(negedge clk);
            valid_txn = 1;
            @(posedge clk);
            #1;
            valid_txn = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_REQUEST);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Stay in IDLE when valid_txn is low", test_num);
            reset_dut();
            ack_txn = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_sm Testbench");
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
        $dumpvars(0,ack_txn, clk, reset, valid_txn, state);
    end

endmodule
