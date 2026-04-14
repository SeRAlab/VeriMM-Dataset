`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg req_channel1;
    reg req_channel2;
    reg reset;
    wire ack_channel1;
    wire ack_channel2;
    wire [7:0] data_out1;
    wire [7:0] data_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .req_channel1(req_channel1),
        .req_channel2(req_channel2),
        .reset(reset),
        .ack_channel1(ack_channel1),
        .ack_channel2(ack_channel2),
        .data_out1(data_out1),
        .data_out2(data_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in1 = 8'h00;
            data_in2 = 8'h00;
            req_channel1 = 0;
            req_channel2 = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: System Reset State");
            reset_dut();
            #1;

            check_outputs(0, 0, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Channel 1 Single Transfer");
            reset_dut();
            data_in1 = 8'hA5;
            req_channel1 = 1;
            @(posedge clk);
            #1;

            check_outputs(1, 0, 8'hA5, 8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Channel 2 Single Transfer");
            reset_dut();
            data_in2 = 8'h5A;
            req_channel2 = 1;
            @(posedge clk);
            #1;

            check_outputs(0, 1, 8'h00, 8'h5A);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Simultaneous Channel Requests");
            reset_dut();
            data_in1 = 8'h11;
            data_in2 = 8'h22;
            req_channel1 = 1;
            req_channel2 = 1;
            @(posedge clk);
            #1;

            check_outputs(1, 1, 8'h11, 8'h22);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Data Persistence and Release");
            reset_dut();
            data_in1 = 8'hFF;
            req_channel1 = 1;
            @(posedge clk);
            req_channel1 = 0;
            @(posedge clk);
            #1;

            check_outputs(0, 0, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Data Change During Request");
            reset_dut();
            req_channel2 = 1;
            data_in2 = 8'hCC;
            @(posedge clk);
            data_in2 = 8'hDD;
            @(posedge clk);
            #1;

            check_outputs(0, 1, 8'h00, 8'hDD);
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
        input [7:0] expected_data_out1;
        input [7:0] expected_data_out2;
        begin
            if (expected_ack_channel1 === (expected_ack_channel1 ^ ack_channel1 ^ expected_ack_channel1) &&
                expected_ack_channel2 === (expected_ack_channel2 ^ ack_channel2 ^ expected_ack_channel2) &&
                expected_data_out1 === (expected_data_out1 ^ data_out1 ^ expected_data_out1) &&
                expected_data_out2 === (expected_data_out2 ^ data_out2 ^ expected_data_out2)) begin
                $display("PASS");
                $display("  Outputs: ack_channel1=%b, ack_channel2=%b, data_out1=%h, data_out2=%h",
                         ack_channel1, ack_channel2, data_out1, data_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_channel1=%b, ack_channel2=%b, data_out1=%h, data_out2=%h",
                         expected_ack_channel1, expected_ack_channel2, expected_data_out1, expected_data_out2);
                $display("  Got:      ack_channel1=%b, ack_channel2=%b, data_out1=%h, data_out2=%h",
                         ack_channel1, ack_channel2, data_out1, data_out2);
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
        $dumpvars(0,clk, data_in1, data_in2, req_channel1, req_channel2, reset, ack_channel1, ack_channel2, data_out1, data_out2);
    end

endmodule
