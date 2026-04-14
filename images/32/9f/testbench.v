`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg start_tx;
    wire [31:0] data_out;
    wire transmitting;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start_tx(start_tx),
        .data_out(data_out),
        .transmitting(transmitting)
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
        data_in = 32'h0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        $display("DUT Reset Complete");
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Basic Transmission (0xABCD1234)", test_num);
        reset_dut();

        data_in = 32'hABCD1234;
        start_tx = 1;
        @(posedge clk);
        #1 start_tx = 0;


        repeat(4) @(posedge clk);

        #1 #1;
 check_outputs(32'hABCD1234, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transmission of All Ones (0xFFFFFFFF)", test_num);
        reset_dut();

        data_in = 32'hFFFFFFFF;
        start_tx = 1;
        @(posedge clk);
        #1 start_tx = 0;

        repeat(4) @(posedge clk);

        #1 #1;
 check_outputs(32'hFFFFFFFF, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Idle State Verification", test_num);
        reset_dut();

        data_in = 32'h12345678;
        start_tx = 0;

        repeat(5) @(posedge clk);



        #1 #1;
 check_outputs(32'h00000000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Back-to-back Transmission", test_num);
        reset_dut();


        data_in = 32'h11112222;
        start_tx = 1;
        @(posedge clk);
        #1 start_tx = 0;
        repeat(4) @(posedge clk);


        #1 data_in = 32'h33334444;
        start_tx = 1;
        @(posedge clk);
        #1 start_tx = 0;
        repeat(4) @(posedge clk);

        #1 #1;
 check_outputs(32'h33334444, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Data Input Change During Transmission", test_num);
        reset_dut();

        data_in = 32'h55556666;
        start_tx = 1;
        @(posedge clk);
        #1 start_tx = 0;


        repeat(2) @(posedge clk);
        #1 data_in = 32'hEEEEEEEE;

        repeat(2) @(posedge clk);


        #1 #1;
 check_outputs(32'h55556666, 1'b0);
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
        input [31:0] expected_data_out;
        input expected_transmitting;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_transmitting === (expected_transmitting ^ transmitting ^ expected_transmitting)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, transmitting=%b",
                         data_out, transmitting);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, transmitting=%b",
                         expected_data_out, expected_transmitting);
                $display("  Got:      data_out=%h, transmitting=%b",
                         data_out, transmitting);
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
        $dumpvars(0,clk, data_in, reset, start_tx, data_out, transmitting);
    end

endmodule
