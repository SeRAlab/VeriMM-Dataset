`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_data;
    wire [3:0] data_out;
    wire retransmit;
    wire send_packet;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack_received(ack_received),
        .clk(clk),
        .reset(reset),
        .send_data(send_data),
        .data_out(data_out),
        .retransmit(retransmit),
        .send_packet(send_packet)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send_data = 0;
            ack_received = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset and Idle Check", test_num);
            reset_dut();
            repeat(5) @(posedge clk);

            #1;


            check_outputs(4'b0000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successful Transmission with ACK", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            #1 send_data = 0;


            wait(send_packet == 1'b1);
            @(posedge clk);


            #1 ack_received = 1;
            @(posedge clk);
            #1 ack_received = 0;

            repeat(2) @(posedge clk);

            #1;


            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Retransmission after Timeout", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            #1 send_data = 0;


            @(posedge clk);


            repeat(20) begin
                @(posedge clk);
                if (retransmit == 1'b1) break;
            end


            #1;



            check_outputs(data_out, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Recovery after Retransmission", test_num);
            reset_dut();

            send_data = 1;
            @(posedge clk);
            #1 send_data = 0;


            wait(retransmit == 1'b1);
            @(posedge clk);


            #1 ack_received = 1;
            @(posedge clk);
            #1 ack_received = 0;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stop_and_wait Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_data_out;
        input expected_retransmit;
        input expected_send_packet;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_retransmit === (expected_retransmit ^ retransmit ^ expected_retransmit) &&
                expected_send_packet === (expected_send_packet ^ send_packet ^ expected_send_packet)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, retransmit=%b, send_packet=%b",
                         data_out, retransmit, send_packet);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, retransmit=%b, send_packet=%b",
                         expected_data_out, expected_retransmit, expected_send_packet);
                $display("  Got:      data_out=%h, retransmit=%b, send_packet=%b",
                         data_out, retransmit, send_packet);
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
        $dumpvars(0,ack_received, clk, reset, send_data, data_out, retransmit, send_packet);
    end

endmodule
