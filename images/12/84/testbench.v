`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack_in;
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire ack_out;
    wire [7:0] data_out;
    wire send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_in(ack_in),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .ack_out(ack_out),
        .data_out(data_out),
        .send(send)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack_in = 0;
            data_in = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %0d: Power-on Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %0d: Basic Transmission", test_num);
            reset_dut();

            data_in = 8'hA5;
            @(posedge clk);


            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase %0d: Sequential Data with ACK", test_num);
            reset_dut();


            data_in = 8'h11;
            repeat(2) @(posedge clk);


            ack_in = 1;
            @(posedge clk);
            ack_in = 0;


            data_in = 8'h22;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h22, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %0d: Window Filling (No ACK)", test_num);
            reset_dut();

            data_in = 8'hD1;
            @(posedge clk);
            data_in = 8'hD2;
            @(posedge clk);
            data_in = 8'hD3;
            @(posedge clk);



            repeat(10) @(posedge clk);



            #1;




            check_outputs(1'b1, 8'hD1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();


            data_in = 8'hFF;
            repeat(3) @(posedge clk);


            reset_dut();


            data_in = 8'h55;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'h55, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_protocol Testbench");
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
        input [7:0] expected_data_out;
        input expected_send;
        begin
            if (expected_ack_out === (expected_ack_out ^ ack_out ^ expected_ack_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_send === (expected_send ^ send ^ expected_send)) begin
                $display("PASS");
                $display("  Outputs: ack_out=%b, data_out=%h, send=%b",
                         ack_out, data_out, send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_out=%b, data_out=%h, send=%b",
                         expected_ack_out, expected_data_out, expected_send);
                $display("  Got:      ack_out=%b, data_out=%h, send=%b",
                         ack_out, data_out, send);
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
        $dumpvars(0,ack_in, clk, data_in, rst, ack_out, data_out, send);
    end

endmodule
