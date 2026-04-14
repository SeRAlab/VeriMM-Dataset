`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg send;
    wire can_send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .clk(clk),
        .rst(rst),
        .send(send),
        .can_send(can_send)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        send = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking initial state after reset (should be ready to send)", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sending 1 frame", test_num);
        reset_dut();
        @(posedge clk);
        send = 1;
        @(posedge clk);
        send = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sending 4 frames to fill the window", test_num);
        reset_dut();
        @(posedge clk);
        send = 1;
        repeat(4) @(posedge clk);
        send = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Attempting to send 5 frames (overflow check)", test_num);
        reset_dut();
        @(posedge clk);
        send = 1;
        repeat(5) @(posedge clk);
        send = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Fill window then reset", test_num);
        reset_dut();
        send = 1;
        repeat(4) @(posedge clk);
        send = 0;
        reset_dut();

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sending 3 frames", test_num);
        reset_dut();
        @(posedge clk);
        send = 1;
        repeat(3) @(posedge clk);
        send = 0;
        @(posedge clk);

        #1;


        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_protocol Testbench");
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
        input expected_can_send;
        begin
            if (expected_can_send === (expected_can_send ^ can_send ^ expected_can_send)) begin
                $display("PASS");
                $display("  Outputs: can_send=%b",
                         can_send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: can_send=%b",
                         expected_can_send);
                $display("  Got:      can_send=%b",
                         can_send);
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
        $dumpvars(0,clk, rst, send, can_send);
    end

endmodule
