`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_request;
    wire [7:0] data_out;
    wire frame_sent;
    wire send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_request(send_request),
        .data_out(data_out),
        .frame_sent(frame_sent),
        .send(send)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            send_request = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Successful Frame Transmission", test_num);
            reset_dut();


            send_request = 1;
            @(posedge clk);
            send_request = 0;


            wait(send == 1 || frame_sent == 1);
            repeat (2) @(posedge clk);


            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Protocol Blocks Without ACK", test_num);
            reset_dut();


            send_request = 1;
            @(posedge clk);
            send_request = 0;


            wait(send == 1);
            @(posedge clk);


            send_request = 1;
            repeat (3) @(posedge clk);




            #1;





            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Sequential Frames", test_num);
            reset_dut();


            send_request = 1;
            @(posedge clk);
            send_request = 0;
            wait(send == 1);
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;


            @(posedge clk);
            send_request = 1;
            @(posedge clk);
            send_request = 0;
            wait(send == 1);
            @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Mid-Transmission", test_num);
            reset_dut();

            send_request = 1;
            @(posedge clk);
            wait(send == 1);


            reset = 1;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0, 1'b0);
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
        input [7:0] expected_data_out;
        input expected_frame_sent;
        input expected_send;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_frame_sent === (expected_frame_sent ^ frame_sent ^ expected_frame_sent) &&
                expected_send === (expected_send ^ send ^ expected_send)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, frame_sent=%b, send=%b",
                         data_out, frame_sent, send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, frame_sent=%b, send=%b",
                         expected_data_out, expected_frame_sent, expected_send);
                $display("  Got:      data_out=%h, frame_sent=%b, send=%b",
                         data_out, frame_sent, send);
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
        $dumpvars(0,ack, clk, reset, send_request, data_out, frame_sent, send);
    end

endmodule
