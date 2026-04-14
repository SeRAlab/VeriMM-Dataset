`timescale 1ns/1ps

module wifi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect;
    reg disconnect;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_controller dut (
        .clk(clk),
        .connect(connect),
        .disconnect(disconnect),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        connect = 0;
        disconnect = 1;
        @(posedge clk);
        #1;
        disconnect = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Full Connection Sequence", test_num);
        reset_dut();
        connect = 1;
        @(posedge clk);
        connect = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(CONNECTED);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Verify CONNECTING State", test_num);
        reset_dut();
        connect = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(CONNECTING);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Disconnect from CONNECTED", test_num);
        reset_dut();
        connect = 1;
        @(posedge clk);
        connect = 0;
        @(posedge clk);
        disconnect = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(DISCONNECTED);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Disconnect during CONNECTING", test_num);
        reset_dut();
        connect = 1;
        @(posedge clk);
        disconnect = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(DISCONNECTED);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Priority (Connect & Disconnect both High)", test_num);
        reset_dut();
        connect = 1;
        disconnect = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(DISCONNECTED);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Stay DISCONNECTED when no inputs", test_num);
        reset_dut();
        connect = 0;
        disconnect = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(DISCONNECTED);
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
        $dumpvars(0,clk, connect, disconnect, state);
    end

endmodule
