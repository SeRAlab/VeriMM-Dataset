`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg send;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .send(send),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            send = 0;
            data_in = 8'h00;
            test_num = test_num + 1;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Initial State after Reset");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Single Data Send");
            reset_dut();

            data_in = 8'hA5;
            send = 1;
            @(posedge clk);
            #1 send = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hA5, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Filling the Window (Size 4)");
            reset_dut();


            data_in = 8'h01; send = 1; @(posedge clk); #1;

            data_in = 8'h02; send = 1; @(posedge clk); #1;

            data_in = 8'h03; send = 1; @(posedge clk); #1;

            data_in = 8'h04; send = 1; @(posedge clk); #1;
            send = 0;
            repeat(1) @(posedge clk);


            #1;



            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Ack and Slide Window");
            reset_dut();


            data_in = 8'h11; send = 1; @(posedge clk); #1;
            data_in = 8'h22; send = 1; @(posedge clk); #1;
            send = 0;
            @(posedge clk);


            ack = 1;
            @(posedge clk);
            #1 ack = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h22, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Overflow Prevention (Sending when Full)");
            reset_dut();


            data_in = 8'hD1; send = 1; @(posedge clk); #1;
            data_in = 8'hD2; send = 1; @(posedge clk); #1;
            data_in = 8'hD3; send = 1; @(posedge clk); #1;
            data_in = 8'hD4; send = 1; @(posedge clk); #1;


            data_in = 8'hEE; send = 1; @(posedge clk); #1;
            send = 0;
            @(posedge clk);


            repeat(4) begin
                ack = 1; @(posedge clk); #1 ack = 0; @(posedge clk);
            end


            #1;



            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Sequential Send and Ack (Wraparound)");
            reset_dut();


            data_in = 8'hAA; send = 1; @(posedge clk); #1 send = 0; @(posedge clk);
            ack = 1; @(posedge clk); #1 ack = 0; @(posedge clk);


            data_in = 8'hBB; send = 1; @(posedge clk); #1 send = 0; @(posedge clk);
            ack = 1; @(posedge clk); #1 ack = 0; @(posedge clk);


            data_in = 8'hCC; send = 1; @(posedge clk); #1 send = 0; @(posedge clk);


            #1;



            check_outputs(8'hCC, 1'b0, 1'b0);
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
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,ack, clk, data_in, reset, send, data_out, empty, full);
    end

endmodule
