`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_data;
    reg timeout;
    wire ack_out;
    wire send_data_out;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_data(send_data),
        .timeout(timeout),
        .ack_out(ack_out),
        .send_data_out(send_data_out),
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
            ack = 0;
            send_data = 0;
            timeout = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Verifying Idle State after Reset", test_num);

            #1;


            check_outputs(1'b0, 1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Successful Data Transmission", test_num);

            send_data = 1;
            @(posedge clk);
            #1;
            send_data = 0;



            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Timeout and Retry Scenario", test_num);

            send_data = 1;
            @(posedge clk);
            #1;
            send_data = 0;


            timeout = 1;
            @(posedge clk);
            #1;
            timeout = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Receiver ACK Generation", test_num);

            send_data = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b1, 1'b1, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Successful Recovery after Timeout", test_num);


            send_data = 1;
            @(posedge clk);
            #1;
            send_data = 0;


            timeout = 1;
            @(posedge clk);
            #1;
            timeout = 0;


            @(posedge clk);
            #1;
            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0, 2'b00);
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
        input expected_ack_out;
        input expected_send_data_out;
        input [1:0] expected_state;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out) &&
                expected_send_data_out === (expected_send_data_out ^ send_data_out ^ expected_send_data_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b, send_data_out=%b, state=%h",
                         ack_out, send_data_out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b, send_data_out=%b, state=%h",
                         expected_ack_out, expected_send_data_out, expected_state);
                $display("  Got:      ack_out=%b, send_data_out=%b, state=%h",
                         ack_out, send_data_out, state);
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
        $dumpvars(0,ack, clk, reset, send_data, timeout, ack_out, send_data_out, state);
    end

endmodule
