`timescale 1ns/1ps

module ARQ_System_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg request_retransmit;
    reg reset;
    wire [3:0] data_out;
    wire error_detected;
    wire parity_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_System dut (
        .clk(clk),
        .data_in(data_in),
        .request_retransmit(request_retransmit),
        .reset(reset),
        .data_out(data_out),
        .error_detected(error_detected),
        .parity_out(parity_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 4'b0000;
            request_retransmit = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Normal Transmit (1010)");
            reset_dut();
            data_in = 4'b1010;
            request_retransmit = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1010, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Normal Transmit (1011)");
            reset_dut();
            data_in = 4'b1011;
            request_retransmit = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1011, 0, 1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Retransmit Request Simulation");
            reset_dut();
            data_in = 4'b1100;
            request_retransmit = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1100, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Boundary Test (0000)");
            reset_dut();
            data_in = 4'b0000;
            request_retransmit = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Boundary Test (1111)");
            reset_dut();
            data_in = 4'b1111;
            request_retransmit = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1111, 0, 0);
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
        input [3:0] expected_data_out;
        input expected_error_detected;
        input expected_parity_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error_detected === (expected_error_detected ^ error_detected ^ expected_error_detected) &&
                expected_parity_out === (expected_parity_out ^ parity_out ^ expected_parity_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error_detected=%b, parity_out=%b",
                         data_out, error_detected, parity_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error_detected=%b, parity_out=%b",
                         expected_data_out, expected_error_detected, expected_parity_out);
                $display("  Got:      data_out=%h, error_detected=%b, parity_out=%b",
                         data_out, error_detected, parity_out);
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
        $dumpvars(0,clk, data_in, request_retransmit, reset, data_out, error_detected, parity_out);
    end

endmodule
