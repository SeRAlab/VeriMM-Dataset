`timescale 1ns/1ps

module ARQ_Protocol_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg parity_check;
    reg reset;
    wire [7:0] data_out;
    wire request_retransmit;
    wire send;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_Protocol dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .parity_check(parity_check),
        .reset(reset),
        .data_out(data_out),
        .request_retransmit(request_retransmit),
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
            data_in = 8'h00;
            data_valid = 0;
            parity_check = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Successful Transmission (No Errors)", test_num);
            reset_dut();

            data_in = 8'hA5;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;


            repeat(2) @(posedge clk);


            parity_check = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hA5, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Retransmission Attempt", test_num);
            reset_dut();

            data_in = 8'h3C;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;


            repeat(2) @(posedge clk);


            parity_check = 1;
            @(posedge clk);



            parity_check = 0;
            repeat(2) @(posedge clk);


            parity_check = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h3C, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple Retransmissions", test_num);
            reset_dut();

            data_in = 8'hFF;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;


            repeat(2) @(posedge clk);
            parity_check = 1;
            @(posedge clk);


            repeat(2) @(posedge clk);
            parity_check = 1;
            @(posedge clk);


            repeat(2) @(posedge clk);
            parity_check = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: IDLE State Persistence", test_num);
            reset_dut();

            data_in = 8'h55;
            data_valid = 0;
            repeat(5) @(posedge clk);


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
        $display("ARQ_Protocol Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_request_retransmit;
        input expected_send;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_request_retransmit === (expected_request_retransmit ^ request_retransmit ^ expected_request_retransmit) &&
                expected_send === (expected_send ^ send ^ expected_send)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, request_retransmit=%b, send=%b",
                         data_out, request_retransmit, send);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, request_retransmit=%b, send=%b",
                         expected_data_out, expected_request_retransmit, expected_send);
                $display("  Got:      data_out=%h, request_retransmit=%b, send=%b",
                         data_out, request_retransmit, send);
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
        $dumpvars(0,clk, data_in, data_valid, parity_check, reset, data_out, request_retransmit, send);
    end

endmodule
