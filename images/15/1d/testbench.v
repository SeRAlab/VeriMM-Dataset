`timescale 1ns/1ps

module bluetooth_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect_signal;
    reg reset;
    reg transfer_signal;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_fsm dut (
        .clk(clk),
        .connect_signal(connect_signal),
        .reset(reset),
        .transfer_signal(transfer_signal),
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
            connect_signal = 0;
            transfer_signal = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset to IDLE");
            test_num = test_num + 1;
            reset_dut();
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Transition IDLE -> CONNECTED");
            test_num = test_num + 1;
            reset_dut();

            connect_signal = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(CONNECTED);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Transition CONNECTED -> DATA_TRANSFER");
            test_num = test_num + 1;
            reset_dut();


            connect_signal = 1;
            @(posedge clk);
            #1;


            transfer_signal = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(DATA_TRANSFER);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Return DATA_TRANSFER -> CONNECTED");
            test_num = test_num + 1;
            reset_dut();


            connect_signal = 1;
            @(posedge clk);
            #1;
            transfer_signal = 1;
            @(posedge clk);
            #1;


            transfer_signal = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(CONNECTED);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Transition CONNECTED -> IDLE");
            test_num = test_num + 1;
            reset_dut();


            connect_signal = 1;
            @(posedge clk);
            #1;


            connect_signal = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: IDLE stays IDLE if only transfer_signal is high");
            test_num = test_num + 1;
            reset_dut();


            connect_signal = 0;
            transfer_signal = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Reset while in DATA_TRANSFER");
            test_num = test_num + 1;
            reset_dut();


            connect_signal = 1;
            @(posedge clk);
            #1;
            transfer_signal = 1;
            @(posedge clk);
            #1;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_fsm Testbench");
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
        $dumpvars(0,clk, connect_signal, reset, transfer_signal, state);
    end

endmodule
