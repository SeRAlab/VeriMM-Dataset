`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg reset;
    reg send_data;
    wire data_sent;
    wire resend_data;
    wire [3:0] state;

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
        .data_sent(data_sent),
        .resend_data(resend_data),
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
            ack_received = 0;
            send_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: System Reset and Idle State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Successful Data Transmission with ACK", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(2) @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Timeout Scenario and Resend Check", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            send_data = 0;



            repeat(15) @(posedge clk);



            #1;




            check_outputs(1'b0, 1'b1, 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Successful ACK after a Resend Attempt", test_num);
            reset_dut();


            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(15) @(posedge clk);


            ack_received = 1;
            @(posedge clk);
            ack_received = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Multiple Sequential Successful Packets", test_num);
            reset_dut();


            send_data = 1; @(posedge clk); send_data = 0;
            repeat(2) @(posedge clk);
            ack_received = 1; @(posedge clk); ack_received = 0;
            repeat(2) @(posedge clk);


            send_data = 1; @(posedge clk); send_data = 0;
            repeat(2) @(posedge clk);
            ack_received = 1; @(posedge clk); ack_received = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 4'h0);
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
        input expected_resend_data;
        input [3:0] expected_state;
        begin
            if (expected_data_sent === (expected_data_sent ^ data_sent ^ expected_data_sent) &&
                expected_resend_data === (expected_resend_data ^ resend_data ^ expected_resend_data) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_sent=%b, resend_data=%b, state=%h",
                         data_sent, resend_data, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_sent=%b, resend_data=%b, state=%h",
                         expected_data_sent, expected_resend_data, expected_state);
                $display("  Got:      data_sent=%b, resend_data=%b, state=%h",
                         data_sent, resend_data, state);
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
        $dumpvars(0,ack_received, clk, reset, send_data, data_sent, resend_data, state);
    end

endmodule
