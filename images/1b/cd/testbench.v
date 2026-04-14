`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send;
    wire data_sent;
    wire ready_to_send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send(send),
        .data_sent(data_sent),
        .ready_to_send(ready_to_send)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ack = 0;
            send = 0;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enter waiting state after send", test_num);
            reset_dut();

            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            #1;


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Complete transaction with ACK", test_num);
            reset_dut();


            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;


            repeat(2) @(posedge clk);


            ack = 1;
            @(posedge clk);
            ack = 0;
            #1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Ignore send signal while waiting for ACK", test_num);
            reset_dut();


            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;


            repeat(2) @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;


            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
            #1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Back-to-back transactions", test_num);
            reset_dut();


            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;


            @(posedge clk);
            send = 1;
            @(posedge clk);
            send = 0;
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
            #1;


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
        $display("stop_and_wait Testbench");
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
        input expected_data_sent;
        input expected_ready_to_send;
        begin
            if (expected_data_sent === (expected_data_sent ^ data_sent ^ expected_data_sent) &&
                expected_ready_to_send === (expected_ready_to_send ^ ready_to_send ^ expected_ready_to_send)) begin
                $display("PASS");
                $display("  Outputs: data_sent=%b, ready_to_send=%b",
                         data_sent, ready_to_send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_sent=%b, ready_to_send=%b",
                         expected_data_sent, expected_ready_to_send);
                $display("  Got:      data_sent=%b, ready_to_send=%b",
                         data_sent, ready_to_send);
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
        $dumpvars(0,ack, clk, reset, send, data_sent, ready_to_send);
    end

endmodule
