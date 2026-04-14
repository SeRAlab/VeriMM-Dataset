`timescale 1ns/1ps

module bluetooth_state_machine_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect;
    reg disconnect;
    reg reset;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_state_machine dut (
        .clk(clk),
        .connect(connect),
        .disconnect(disconnect),
        .reset(reset),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            connect = 0;
            disconnect = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: Initial Reset to IDLE", test_num);
            reset_dut();
            repeat(1) @(posedge clk);
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: IDLE to CONNECTED", test_num);
            reset_dut();
            @(negedge clk);
            connect = 1;
            @(negedge clk);
            connect = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(CONNECTED);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: CONNECTED to DISCONNECTED", test_num);
            reset_dut();

            @(negedge clk);
            connect = 1;
            @(negedge clk);
            connect = 0;

            @(negedge clk);
            disconnect = 1;
            @(negedge clk);
            disconnect = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(DISCONNECTED);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %03d: DISCONNECTED to IDLE via reset", test_num);
            reset_dut();

            @(negedge clk);
            connect = 1;
            @(negedge clk);
            connect = 0;

            @(negedge clk);
            disconnect = 1;
            @(negedge clk);
            disconnect = 0;

            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %03d: IDLE ignores disconnect", test_num);
            reset_dut();
            @(negedge clk);
            disconnect = 1;
            @(negedge clk);
            disconnect = 0;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %03d: CONNECTED remains stable", test_num);
            reset_dut();
            @(negedge clk);
            connect = 1;
            @(negedge clk);
            connect = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(CONNECTED);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %03d: Full cycle verification", test_num);
            reset_dut();

            @(negedge clk); connect = 1;
            @(negedge clk); connect = 0;
            @(negedge clk); disconnect = 1;
            @(negedge clk); disconnect = 0;
            @(negedge clk); reset = 1;
            @(negedge clk); reset = 0;
            repeat(1) @(posedge clk);
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
        $display("bluetooth_state_machine Testbench");
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
        $dumpvars(0,clk, connect, disconnect, reset, state);
    end

endmodule
