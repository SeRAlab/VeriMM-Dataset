`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] ADDR;
    reg [7:0] DATA;
    reg SCL;
    reg SDA;
    reg START;
    reg STOP;
    wire ACK;
    wire ERROR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .DATA(DATA),
        .SCL(SCL),
        .SDA(SDA),
        .START(START),
        .STOP(STOP),
        .ACK(ACK),
        .ERROR(ERROR)
    );

    // Clock generation (10ns period)
    initial begin
        SCL = 0;
        forever #5 SCL = ~SCL;
    end

        task reset_dut;

        begin
            START = 0;
            STOP = 1;
            ADDR = 8'h00;
            DATA = 8'h00;
            SDA = 1;
            repeat(2) @(negedge SCL);
            STOP = 0;
            repeat(1) @(negedge SCL);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Successful Transaction (0xA5, 0x5A)", test_num);
            reset_dut();
            ADDR = 8'hA5;
            DATA = 8'h5A;


            @(negedge SCL) START = 1;
            @(negedge SCL) START = 0;


            send_byte_with_ack(8'hA5, 0);
            send_byte_with_ack(8'h5A, 0);

            #10;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Address NACK Failure", test_num);
            reset_dut();
            ADDR = 8'h12;
            DATA = 8'h34;

            @(negedge SCL) START = 1;
            @(negedge SCL) START = 0;

            send_byte_with_ack(8'h12, 1);

            #10;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Data NACK Failure", test_num);
            reset_dut();
            ADDR = 8'hAA;
            DATA = 8'hBB;

            @(negedge SCL) START = 1;
            @(negedge SCL) START = 0;

            send_byte_with_ack(8'hAA, 0);
            send_byte_with_ack(8'hBB, 1);

            #10;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: STOP Signal Interruption", test_num);
            reset_dut();
            ADDR = 8'hFF;

            @(negedge SCL) START = 1;
            @(negedge SCL) START = 0;


            repeat(4) @(negedge SCL) SDA = 1;

            @(negedge SCL) STOP = 1;
            @(negedge SCL) STOP = 0;

            #10;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Zero-Value Success (0x00, 0x00)", test_num);
            reset_dut();
            ADDR = 8'h00;
            DATA = 8'h00;

            @(negedge SCL) START = 1;
            @(negedge SCL) START = 0;

            send_byte_with_ack(8'h00, 0);
            send_byte_with_ack(8'h00, 0);

            #10;
            #1;

            check_outputs(1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_ACK;
        input expected_ERROR;
        begin
            if (expected_ACK === (expected_ACK ^ ACK ^ expected_ACK) &&
                expected_ERROR === (expected_ERROR ^ ERROR ^ expected_ERROR)) begin
                $display("PASS");
                $display("  Outputs: ACK=%b, ERROR=%b",
                         ACK, ERROR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACK=%b, ERROR=%b",
                         expected_ACK, expected_ERROR);
                $display("  Got:      ACK=%b, ERROR=%b",
                         ACK, ERROR);
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
        $dumpvars(0,ADDR, DATA, SCL, SDA, START, STOP, ACK, ERROR);
    end

endmodule
