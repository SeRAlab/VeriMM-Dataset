`timescale 1ns/1ps

module arq_system_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg error_detected;
    reg reset;
    wire ack;
    wire [7:0] data_out;
    wire request_retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arq_system dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .error_detected(error_detected),
        .reset(reset),
        .ack(ack),
        .data_out(data_out),
        .request_retransmit(request_retransmit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            data_in = 8'h0;
            data_valid = 0;
            error_detected = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Successful transmission", test_num);
            reset_dut();

            data_in = 8'hA5;
            data_valid = 1;
            error_detected = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hA5, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Error detected, request retransmit", test_num);
            reset_dut();

            data_in = 8'hFF;
            data_valid = 1;
            error_detected = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Retransmission sequence", test_num);
            reset_dut();


            data_in = 8'h33;
            data_valid = 1;
            error_detected = 1;
            @(posedge clk);


            data_in = 8'h33;
            data_valid = 1;
            error_detected = 0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b1, 8'h33, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Idle state", test_num);
            reset_dut();

            data_in = 8'hBC;
            data_valid = 0;
            error_detected = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Consecutive successful transfers", test_num);
            reset_dut();


            data_in = 8'h11;
            data_valid = 1;
            error_detected = 0;
            @(posedge clk);


            data_in = 8'h22;
            data_valid = 1;
            error_detected = 0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b1, 8'h22, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Repeated errors", test_num);
            reset_dut();


            data_in = 8'hEE;
            data_valid = 1;
            error_detected = 1;
            @(posedge clk);


            data_in = 8'hEE;
            data_valid = 1;
            error_detected = 1;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Error signal high but data_valid low", test_num);
            reset_dut();

            data_in = 8'hAA;
            data_valid = 0;
            error_detected = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arq_system Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_ack;
        input [7:0] expected_data_out;
        input expected_request_retransmit;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_request_retransmit === (expected_request_retransmit ^ request_retransmit ^ expected_request_retransmit)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h, request_retransmit=%b",
                         ack, data_out, request_retransmit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h, request_retransmit=%b",
                         expected_ack, expected_data_out, expected_request_retransmit);
                $display("  Got:      ack=%b, data_out=%h, request_retransmit=%b",
                         ack, data_out, request_retransmit);
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
        $dumpvars(0,clk, data_in, data_valid, error_detected, reset, ack, data_out, request_retransmit);
    end

endmodule
