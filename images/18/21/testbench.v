`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req_channel1;
    reg req_channel2;
    reg reset;
    wire ack_channel1;
    wire ack_channel2;
    wire [15:0] address_out;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req_channel1(req_channel1),
        .req_channel2(req_channel2),
        .reset(reset),
        .ack_channel1(ack_channel1),
        .ack_channel2(ack_channel2),
        .address_out(address_out),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        req_channel1 = 0;
        req_channel2 = 0;
        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: System Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b0, 16'h0000, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Channel 1 Single Request", test_num);
        reset_dut();

        @(posedge clk);
        req_channel1 = 1;


        repeat(5) @(posedge clk);




        #1;





        check_outputs(1'b1, 1'b0, address_out, data_out);

        req_channel1 = 0;
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Channel 2 Single Request", test_num);
        reset_dut();

        @(posedge clk);
        req_channel2 = 1;

        repeat(5) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b1, address_out, data_out);

        req_channel2 = 0;
        @(posedge clk);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Simultaneous Requests (Priority)", test_num);
        reset_dut();

        @(posedge clk);
        req_channel1 = 1;
        req_channel2 = 1;

        repeat(5) @(posedge clk);


        #1;



        check_outputs(1'b1, 1'b0, address_out, data_out);

        req_channel1 = 0;
        req_channel2 = 0;
        @(posedge clk);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Sequential Requests", test_num);
        reset_dut();


        @(posedge clk);
        req_channel1 = 1;
        repeat(3) @(posedge clk);
        req_channel1 = 0;


        @(posedge clk);
        req_channel2 = 1;
        repeat(5) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b1, address_out, data_out);

        req_channel2 = 0;
        @(posedge clk);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Idle State Stability", test_num);
        reset_dut();


        repeat(10) @(posedge clk);


        #1;



        check_outputs(1'b0, 1'b0, 16'h0000, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_ack_channel1;
        input expected_ack_channel2;
        input [15:0] expected_address_out;
        input [7:0] expected_data_out;
        begin
            if (expected_ack_channel1 === (expected_ack_channel1 ^ ack_channel1 ^ expected_ack_channel1) &&
                expected_ack_channel2 === (expected_ack_channel2 ^ ack_channel2 ^ expected_ack_channel2) &&
                expected_address_out === (expected_address_out ^ address_out ^ expected_address_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack_channel1=%b, ack_channel2=%b, address_out=%h, data_out=%h",
                         ack_channel1, ack_channel2, address_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_channel1=%b, ack_channel2=%b, address_out=%h, data_out=%h",
                         expected_ack_channel1, expected_ack_channel2, expected_address_out, expected_data_out);
                $display("  Got:      ack_channel1=%b, ack_channel2=%b, address_out=%h, data_out=%h",
                         ack_channel1, ack_channel2, address_out, data_out);
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
        $dumpvars(0,clk, req_channel1, req_channel2, reset, ack_channel1, ack_channel2, address_out, data_out);
    end

endmodule
