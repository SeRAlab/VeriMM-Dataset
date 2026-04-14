`timescale 1ns/1ps

module bluetooth_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect_fail;
    reg connect_success;
    reg disconnect;
    reg reset;
    reg start_connect;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_controller dut (
        .clk(clk),
        .connect_fail(connect_fail),
        .connect_success(connect_success),
        .disconnect(disconnect),
        .reset(reset),
        .start_connect(start_connect),
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
            start_connect = 0;
            connect_fail = 0;
            connect_success = 0;
            disconnect = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successful Connection Path", test_num);
            reset_dut();


            @(negedge clk);
            start_connect = 1;
            @(negedge clk);
            start_connect = 0;


            connect_success = 1;
            @(negedge clk);
            connect_success = 0;

            #1;


            check_outputs(2'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Connection Failure Path", test_num);
            reset_dut();


            @(negedge clk);
            start_connect = 1;
            @(negedge clk);
            start_connect = 0;


            connect_fail = 1;
            @(negedge clk);
            connect_fail = 0;

            #1;


            check_outputs(2'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Cycle Disconnect Path", test_num);
            reset_dut();


            @(negedge clk);
            start_connect = 1;
            @(negedge clk);
            start_connect = 0;


            connect_success = 1;
            @(negedge clk);
            connect_success = 0;


            disconnect = 1;
            @(negedge clk);
            disconnect = 0;

            #1;


            check_outputs(2'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stay in IDLE", test_num);
            reset_dut();

            repeat (3) @(posedge clk);

            #1;


            check_outputs(2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset while Connected", test_num);
            reset_dut();


            @(negedge clk);
            start_connect = 1;
            @(negedge clk);
            start_connect = 0;
            connect_success = 1;
            @(negedge clk);
            connect_success = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);

            #1;


            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Ignore Invalid Signal (fail while connected)", test_num);
            reset_dut();


            @(negedge clk);
            start_connect = 1;
            @(negedge clk);
            start_connect = 0;
            connect_success = 1;
            @(negedge clk);
            connect_success = 0;


            connect_fail = 1;
            @(negedge clk);
            connect_fail = 0;

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
        $display("bluetooth_controller Testbench");
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
        $dumpvars(0,clk, connect_fail, connect_success, disconnect, reset, start_connect, state);
    end

endmodule
