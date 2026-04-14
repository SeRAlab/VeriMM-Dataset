`timescale 1ns/1ps

module pcie_tx_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg signal_error;
    reg start;
    reg transmission_complete;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_tx_fsm dut (
        .clk(clk),
        .reset(reset),
        .signal_error(signal_error),
        .start(start),
        .transmission_complete(transmission_complete),
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
            signal_error = 0;
            start = 0;
            transmission_complete = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset to Idle", test_num);
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Idle to Transmitting", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Normal Cycle (Idle-TX-Idle)", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);

            transmission_complete = 1;
            @(posedge clk);
            #1 transmission_complete = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Idle to Error", test_num);
            reset_dut();
            signal_error = 1;
            @(posedge clk);
            #1 signal_error = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting to Error", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);

            signal_error = 1;
            @(posedge clk);
            #1 signal_error = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Error Priority over Start", test_num);
            reset_dut();
            start = 1;
            signal_error = 1;
            @(posedge clk);
            #1 start = 0; signal_error = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Recovery from Error via Reset", test_num);
            reset_dut();
            signal_error = 1;
            @(posedge clk);
            #1 signal_error = 0;
            @(posedge clk);

            reset_dut();
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
        $display("pcie_tx_fsm Testbench");
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
        $dumpvars(0,clk, reset, signal_error, start, transmission_complete, state);
    end

endmodule
