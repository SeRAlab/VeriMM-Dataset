`timescale 1ns/1ps

module ARQ_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [3:0] data_in;
    reg reset;
    wire [3:0] data_out;
    wire error_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ dut (
        .ack(ack),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out),
        .error_detected(error_detected)
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
        data_in = 4'b0000;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset state check");
        reset_dut();

        #1;


        check_outputs(4'b0000, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Valid data transmission (1010)");
        reset_dut();
        data_in = 4'b1010;
        ack = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1010, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Invalid data transmission (1011)");
        reset_dut();
        data_in = 4'b1011;
        ack = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0000, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Invalid data transmission (0001)");
        reset_dut();
        data_in = 4'b0001;
        ack = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0000, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Valid data transmission (1111)");
        reset_dut();
        data_in = 4'b1111;
        ack = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1111, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Valid data transmission (0011)");
        reset_dut();
        data_in = 4'b0011;
        ack = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0011, 0);
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
        input [3:0] expected_data_out;
        input expected_error_detected;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error_detected === (expected_error_detected ^ error_detected ^ expected_error_detected)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error_detected=%b",
                         data_out, error_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error_detected=%b",
                         expected_data_out, expected_error_detected);
                $display("  Got:      data_out=%h, error_detected=%b",
                         data_out, error_detected);
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
        $dumpvars(0,ack, clk, data_in, reset, data_out, error_detected);
    end

endmodule
