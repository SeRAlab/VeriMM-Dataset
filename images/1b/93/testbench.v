`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg start_tx;
    wire [7:0] data_out;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start_tx(start_tx),
        .data_out(data_out),
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
        start_tx = 0;
        ack = 0;
        data_in = 8'h00;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Normal Successful Transmission", test_num);
        reset_dut();


        data_in = 8'hAA;
        start_tx = 1;
        @(posedge clk);
        #1;

        start_tx = 0;
        @(posedge clk);
        #1;

        ack = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'hAA, 2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Persistence in WAIT_FOR_ACK", test_num);
        reset_dut();

        data_in = 8'h55;
        start_tx = 1;
        @(posedge clk);
        #1;

        start_tx = 0;
        @(posedge clk);
        #1;

        ack = 0;
        repeat(3) @(posedge clk);
        #1;


        #1;



        check_outputs(8'h55, 2'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data Output during TRANSMITTING state", test_num);
        reset_dut();

        data_in = 8'hF0;
        start_tx = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(8'hF0, 2'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Idle State Maintenance", test_num);
        reset_dut();

        start_tx = 0;
        repeat(5) @(posedge clk);
        #1;


        #1;



        check_outputs(8'h00, 2'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Immediate transition on ACK", test_num);
        reset_dut();

        data_in = 8'h12;
        start_tx = 1;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        ack = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h12, 2'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential Transmissions", test_num);
        reset_dut();


        data_in = 8'h01;
        start_tx = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        ack = 1;
        @(posedge clk); #1;


        data_in = 8'h02;
        start_tx = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        ack = 1;
        @(posedge clk); #1;

        #1;


        check_outputs(8'h02, 2'd0);
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
        input [1:0] expected_state;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, state=%h",
                         data_out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, state=%h",
                         expected_data_out, expected_state);
                $display("  Got:      data_out=%h, state=%h",
                         data_out, state);
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
        $dumpvars(0,ack, clk, data_in, reset, start_tx, data_out, state);
    end

endmodule
