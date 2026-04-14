`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg error_detected;
    reg rst;
    wire ack;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ dut (
        .clk(clk),
        .data_in(data_in),
        .error_detected(error_detected),
        .rst(rst),
        .ack(ack),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 5'b0;
            error_detected = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Basic successful transmission");
            reset_dut();

            data_in = 5'h0A;
            error_detected = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Error detection (resend last valid)");
            reset_dut();


            data_in = 5'h15;
            error_detected = 0;
            @(posedge clk);
            #2;


            data_in = 5'h0E;
            error_detected = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Recovery after error");
            reset_dut();


            data_in = 5'h01;
            error_detected = 0;
            @(posedge clk);


            data_in = 5'h02;
            error_detected = 1;
            @(posedge clk);


            data_in = 5'h02;
            error_detected = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 5'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Consecutive errors");
            reset_dut();


            data_in = 5'h1F;
            error_detected = 0;
            @(posedge clk);


            data_in = 5'h00;
            error_detected = 1;
            @(posedge clk);
            data_in = 5'h07;
            error_detected = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b0, 5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Reset behavior");
            reset_dut();


            data_in = 5'h10;
            error_detected = 0;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            #2 rst = 0;
            #2;


            #1;



            check_outputs(1'b0, 5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Stream of valid data");
            reset_dut();

            data_in = 5'h01; error_detected = 0; @(posedge clk);
            data_in = 5'h02; error_detected = 0; @(posedge clk);
            data_in = 5'h03; error_detected = 0; @(posedge clk);
            data_in = 5'h04; error_detected = 0; @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 5'h04);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ Testbench");
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
        input expected_ack;
        input [4:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%b, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, data_in, error_detected, rst, ack, data_out);
    end

endmodule
