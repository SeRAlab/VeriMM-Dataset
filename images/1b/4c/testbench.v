`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg packet_arrival;
    reg reset;
    wire can_receive;
    wire can_send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .clk(clk),
        .enable(enable),
        .packet_arrival(packet_arrival),
        .reset(reset),
        .can_receive(can_receive),
        .can_send(can_send)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            packet_arrival = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset State...");
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Send One Packet...");
            reset_dut();
            enable = 1;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Fill Window (3 Packets)...");
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: ACK when Full...");
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            enable = 0;
            packet_arrival = 1;
            @(posedge clk);
            packet_arrival = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Empty Window via ACKs...");
            reset_dut();
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;
            packet_arrival = 1;
            repeat(2) @(posedge clk);
            packet_arrival = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Simultaneous Send/Receive...");
            reset_dut();
            enable = 1;
            @(posedge clk);

            enable = 1;
            packet_arrival = 1;
            @(posedge clk);
            enable = 0;
            packet_arrival = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Overflow Protection...");
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_controller Testbench");
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
        input expected_can_receive;
        input expected_can_send;
        begin
            if (expected_can_receive === (expected_can_receive ^ can_receive ^ expected_can_receive) &&
                expected_can_send === (expected_can_send ^ can_send ^ expected_can_send)) begin
                $display("PASS");
                $display("  Outputs: can_receive=%b, can_send=%b",
                         can_receive, can_send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: can_receive=%b, can_send=%b",
                         expected_can_receive, expected_can_send);
                $display("  Got:      can_receive=%b, can_send=%b",
                         can_receive, can_send);
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
        $dumpvars(0,clk, enable, packet_arrival, reset, can_receive, can_send);
    end

endmodule
