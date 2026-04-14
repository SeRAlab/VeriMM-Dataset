`timescale 1ns/1ps

module wifi_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect;
    reg disconnect;
    reg reset;
    reg start;
    wire [2:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_module dut (
        .clk(clk),
        .connect(connect),
        .disconnect(disconnect),
        .reset(reset),
        .start(start),
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
            start = 0;
            connect = 0;
            disconnect = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Transition IDLE -> CONNECTING", test_num);

            start = 1;
            @(posedge clk);
            #1 start = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(S_CONNECTING);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Transition CONNECTING -> CONNECTED", test_num);


            start = 1;
            @(posedge clk);
            #1 start = 0;


            @(posedge clk);
            #1 connect = 1;
            @(posedge clk);
            #1 connect = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(S_CONNECTED);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Transition CONNECTED -> DISCONNECTING", test_num);


            start = 1; @(posedge clk); #1 start = 0;
            @(posedge clk); #1 connect = 1; @(posedge clk); #1 connect = 0;


            @(posedge clk);
            #1 disconnect = 1;
            @(posedge clk);
            #1 disconnect = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(S_DISCONNECTING);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Transition DISCONNECTING -> DISCONNECTED", test_num);


            start = 1; @(posedge clk); #1 start = 0;
            @(posedge clk); #1 connect = 1; @(posedge clk); #1 connect = 0;
            @(posedge clk); #1 disconnect = 1; @(posedge clk); #1 disconnect = 0;


            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(S_DISCONNECTED);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Verify Reset from CONNECTED state", test_num);


            start = 1; @(posedge clk); #1 start = 0;
            @(posedge clk); #1 connect = 1; @(posedge clk); #1 connect = 0;


            @(posedge clk);
            #1 reset = 1;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(S_IDLE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Verify state after full cycle completion", test_num);


            start = 1; @(posedge clk); #1 start = 0;
            @(posedge clk); #1 connect = 1; @(posedge clk); #1 connect = 0;
            @(posedge clk); #1 disconnect = 1; @(posedge clk); #1 disconnect = 0;

            repeat(3) @(posedge clk);
            #1;


            if (state == S_IDLE || state == S_DISCONNECTED) begin
                pass_count = pass_count + 1;
                $display("PASS: Logic reached terminal/ready state");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Logic stuck in unexpected state %h", state);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_module Testbench");
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
        input [2:0] expected_state;
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
        $dumpvars(0,clk, connect, disconnect, reset, start, state);
    end

endmodule
