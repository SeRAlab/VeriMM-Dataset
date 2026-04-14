`timescale 1ns/1ps

module stop_and_wait_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg rst;
    reg send_data;
    wire data_sent;
    wire [3:0] state;
    wire timeout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stop_and_wait dut (
        .ack_received(ack_received),
        .clk(clk),
        .rst(rst),
        .send_data(send_data),
        .data_sent(data_sent),
        .state(state),
        .timeout(timeout)
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
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System Reset Verification", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successful Transmission and ACK", test_num);
            reset_dut();


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(2) @(posedge clk);


            ack_received = 1;
            @(posedge clk);
            ack_received = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Timeout Scenario (No ACK)", test_num);
            reset_dut();


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;



            repeat(15) @(posedge clk);




            #1;





            check_outputs(data_sent, state, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Delayed ACK", test_num);
            reset_dut();

            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;


            repeat(5) @(posedge clk);

            ack_received = 1;
            @(posedge clk);
            ack_received = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 4'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Successful Transfers", test_num);
            reset_dut();


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;
            repeat(2) @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;
            repeat(2) @(posedge clk);


            @(posedge clk);
            send_data = 1;
            @(posedge clk);
            send_data = 0;
            repeat(2) @(posedge clk);
            ack_received = 1;
            @(posedge clk);
            ack_received = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 4'h0, 1'b0);
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
        input [3:0] expected_state;
        input expected_timeout;
        begin
            if (expected_data_sent === (expected_data_sent ^ data_sent ^ expected_data_sent) &&
                expected_state === (expected_state ^ state ^ expected_state) &&
                expected_timeout === (expected_timeout ^ timeout ^ expected_timeout)) begin
                $display("PASS");
                $display("  Outputs: data_sent=%b, state=%h, timeout=%b",
                         data_sent, state, timeout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_sent=%b, state=%h, timeout=%b",
                         expected_data_sent, expected_state, expected_timeout);
                $display("  Got:      data_sent=%b, state=%h, timeout=%b",
                         data_sent, state, timeout);
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
        $dumpvars(0,ack_received, clk, rst, send_data, data_sent, state, timeout);
    end

endmodule
