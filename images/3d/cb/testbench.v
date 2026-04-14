`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst;
    wire ack;
    wire [7:0] data_out;
    wire request_retransmit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
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
            rst = 1;
            data_in = 0;
            data_valid = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Successful Transmission (Even Parity)", test_num);
            reset_dut();

            data_in = 8'hAA;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;


            #1;



            check_outputs(1'b1, 8'hAA, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Error Detection (Odd Parity)", test_num);
            reset_dut();

            data_in = 8'hAB;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;


            #1;



            check_outputs(1'b0, 8'h00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Retransmission Recovery", test_num);
            reset_dut();


            data_in = 8'h01;
            data_valid = 1;
            @(posedge clk);
            #1;


            data_in = 8'h03;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;


            #1;



            check_outputs(1'b1, 8'h03, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Value 0xFF", test_num);
            reset_dut();

            data_in = 8'hFF;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;

            #1;


            check_outputs(1'b1, 8'hFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Value 0x00", test_num);
            reset_dut();

            data_in = 8'h00;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;

            #1;


            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle State (data_valid=0)", test_num);
            reset_dut();

            data_in = 8'hAA;
            data_valid = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Sequential Valid Packets", test_num);
            reset_dut();


            data_in = 8'h33;
            data_valid = 1;
            @(posedge clk);
            #1;


            data_in = 8'h55;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;


            #1;



            check_outputs(1'b1, 8'h55, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_System Testbench");
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
        $dumpvars(0,clk, data_in, data_valid, rst, ack, data_out, request_retransmit);
    end

endmodule
