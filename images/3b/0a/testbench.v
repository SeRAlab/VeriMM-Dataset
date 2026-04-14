`timescale 1ns/1ps

module StopAndWait_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg send_packet;
    wire ack_received;
    wire packet_sent;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    StopAndWait dut (
        .clk(clk),
        .rst(rst),
        .send_packet(send_packet),
        .ack_received(ack_received),
        .packet_sent(packet_sent)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            send_packet = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Packet Send and ACK", test_num);
            reset_dut();

            @(posedge clk);
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;



            wait(ack_received === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Sequential Packets", test_num);
            reset_dut();


            @(posedge clk);
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            wait(ack_received === 1'b1);
            @(posedge clk);


            @(posedge clk);
            send_packet = 1;
            @(posedge clk);
            send_packet = 0;
            wait(ack_received === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Protocol Robustness - Overlapping Send Requests", test_num);
            reset_dut();

            @(posedge clk);
            send_packet = 1;
            @(posedge clk);



            send_packet = 1;
            @(posedge clk);
            send_packet = 0;


            wait(ack_received === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify packet_sent Activation", test_num);
            reset_dut();

            @(posedge clk);
            send_packet = 1;


            wait(packet_sent === 1'b1);



            #1;




            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("StopAndWait Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_ack_received;
        input expected_packet_sent;
        begin
            if (expected_ack_received === (expected_ack_received ^ ack_received ^ expected_ack_received) &&
                expected_packet_sent === (expected_packet_sent ^ packet_sent ^ expected_packet_sent)) begin
                $display("PASS");
                $display("  Outputs: ack_received=%b, packet_sent=%b",
                         ack_received, packet_sent);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_received=%b, packet_sent=%b",
                         expected_ack_received, expected_packet_sent);
                $display("  Got:      ack_received=%b, packet_sent=%b",
                         ack_received, packet_sent);
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
        $dumpvars(0,clk, rst, send_packet, ack_received, packet_sent);
    end

endmodule
