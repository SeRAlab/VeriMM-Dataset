`timescale 1ns/1ps

module wifi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connected;
    reg disconnect;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_controller dut (
        .clk(clk),
        .connected(connected),
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
            @(posedge clk);
            reset = 1;
            start = 0;
            connected = 0;
            disconnect = 0;
            #10;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: IDLE to CONNECTING", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            #1;


            check_outputs(CONNECTING);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: IDLE to CONNECTED", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            connected = 1;
            @(posedge clk);
            connected = 0;

            #1;


            check_outputs(CONNECTED);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: CONNECTED to DISCONNECTED", test_num);
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            connected = 1;
            @(posedge clk);
            connected = 0;


            disconnect = 1;
            @(posedge clk);
            disconnect = 0;

            #1;


            check_outputs(DISCONNECTED);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: DISCONNECTED to CONNECTING via start", test_num);
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            connected = 1;
            @(posedge clk);
            connected = 0;
            disconnect = 1;
            @(posedge clk);
            disconnect = 0;


            start = 1;
            @(posedge clk);
            start = 0;

            #1;


            check_outputs(CONNECTING);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: CONNECTING stay in state on disconnect", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            disconnect = 1;
            @(posedge clk);
            disconnect = 0;

            #1;


            check_outputs(CONNECTING);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Stay in IDLE if start is low", test_num);
            reset_dut();

            repeat(3) @(posedge clk);

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
        $display("wifi_controller Testbench");
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
        $dumpvars(0,clk, connected, disconnect, reset, start, state);
    end

endmodule
