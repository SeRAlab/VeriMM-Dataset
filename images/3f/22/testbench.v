`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg receive_start;
    reg reset;
    reg send_start;
    wire busy;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .receive_start(receive_start),
        .reset(reset),
        .send_start(send_start),
        .busy(busy),
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
        send_start = 0;
        receive_start = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power-on Reset check", test_num);
        reset_dut();
        #1;

        check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: IDLE to SENDING transition", test_num);
        reset_dut();
        send_start = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, SENDING);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SENDING back to IDLE transition", test_num);
        reset_dut();
        send_start = 1;
        @(posedge clk);
        #1;
        send_start = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: IDLE to RECEIVING transition", test_num);
        reset_dut();
        receive_start = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, RECEIVING);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: RECEIVING back to IDLE transition", test_num);
        reset_dut();
        receive_start = 1;
        @(posedge clk);
        #1;
        receive_start = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, IDLE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: State Persistence (SENDING ignores RECEIVE)", test_num);
        reset_dut();
        send_start = 1;
        @(posedge clk);
        #1;
        receive_start = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, SENDING);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simultaneous start signals from IDLE", test_num);
        reset_dut();
        send_start = 1;
        receive_start = 1;
        @(posedge clk);
        #1;

        if (state == SENDING || state == RECEIVING) begin
             #1;

             check_outputs(1'b1, state);
        end else begin
             #1;

             check_outputs(1'b1, SENDING);
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
        input expected_busy;
        input [1:0] expected_state;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, state=%h",
                         busy, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, state=%h",
                         expected_busy, expected_state);
                $display("  Got:      busy=%b, state=%h",
                         busy, state);
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
        $dumpvars(0,clk, receive_start, reset, send_start, busy, state);
    end

endmodule
