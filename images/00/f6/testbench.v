`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg receive;
    reg rst;
    reg send;
    wire [7:0] data_out;
    wire data_ready;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .receive(receive),
        .rst(rst),
        .send(send),
        .data_out(data_out),
        .data_ready(data_ready),
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
        data_in = 8'h0;
        receive = 0;
        send = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset to IDLE", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b0, IDLE);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transition to RECEIVING", test_num);
        reset_dut();
        receive = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h00, 1'b1, RECEIVING);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transition to TRANSMITTING", test_num);
        reset_dut();
        send = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h00, 1'b1, TRANSMITTING);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Receive data transfer verification", test_num);
        reset_dut();
        receive = 1;
        data_in = 8'hA5;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'hA5, 1'b1, RECEIVING);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transmit data transfer verification", test_num);
        reset_dut();
        send = 1;
        data_in = 8'h5A;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h5A, 1'b1, TRANSMITTING);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simultaneous Send and Receive (Priority Check)", test_num);
        reset_dut();
        receive = 1;
        send = 1;
        data_in = 8'hFF;
        @(posedge clk);
        #2;



        if (state == RECEIVING)
            #1;

            check_outputs(8'hFF, 1'b1, RECEIVING);
        else
            #1;

            check_outputs(8'hFF, 1'b1, TRANSMITTING);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [7:0] expected_data_out;
        input expected_data_ready;
        input [1:0] expected_state;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b, state=%h",
                         data_out, data_ready, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b, state=%h",
                         expected_data_out, expected_data_ready, expected_state);
                $display("  Got:      data_out=%h, data_ready=%b, state=%h",
                         data_out, data_ready, state);
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
        $dumpvars(0,clk, data_in, receive, rst, send, data_out, data_ready, state);
    end

endmodule
