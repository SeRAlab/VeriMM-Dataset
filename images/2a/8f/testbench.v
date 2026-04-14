`timescale 1ns/1ps

module stop_and_wait_arq_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg rst;
    reg send_data;
    wire data_out;
    wire resend;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait_arq dut (
        .ack_received(ack_received),
        .clk(clk),
        .rst(rst),
        .send_data(send_data),
        .data_out(data_out),
        .resend(resend),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack_received = 0;
            send_data = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Successful Transmission (Send -> ACK)", test_num);
            reset_dut();


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;


            @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;


            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Timeout and Resend Trigger", test_num);
            reset_dut();


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;



            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Recovery after Resend", test_num);
            reset_dut();


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;
            repeat(10) @(posedge clk);


            @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;


            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Back-to-back Transmission Request", test_num);
            reset_dut();


            @(posedge clk);
            send_data = 1;


            @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;


            @(posedge clk);



            #1;




            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stop_and_wait_arq Testbench");
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
        input expected_data_out;
        input expected_resend;
        input expected_state;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_resend === (expected_resend ^ resend ^ expected_resend) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, resend=%b, state=%b",
                         data_out, resend, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, resend=%b, state=%b",
                         expected_data_out, expected_resend, expected_state);
                $display("  Got:      data_out=%b, resend=%b, state=%b",
                         data_out, resend, state);
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
        $dumpvars(0,ack_received, clk, rst, send_data, data_out, resend, state);
    end

endmodule
