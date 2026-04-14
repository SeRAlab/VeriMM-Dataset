`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bytes_to_transfer1;
    reg [7:0] bytes_to_transfer2;
    reg clk;
    reg reset;
    reg start_channel1;
    reg start_channel2;
    wire done_channel1;
    wire done_channel2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .bytes_to_transfer1(bytes_to_transfer1),
        .bytes_to_transfer2(bytes_to_transfer2),
        .clk(clk),
        .reset(reset),
        .start_channel1(start_channel1),
        .start_channel2(start_channel2),
        .done_channel1(done_channel1),
        .done_channel2(done_channel2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_channel1 = 0;
            start_channel2 = 0;
            bytes_to_transfer1 = 0;
            bytes_to_transfer2 = 0;
            #20;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Channel 1 transfer (5 bytes)");
            reset_dut();
            bytes_to_transfer1 = 8'd5;

            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;


            wait(done_channel1 == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Channel 2 transfer (12 bytes)");
            reset_dut();
            bytes_to_transfer2 = 8'd12;

            @(posedge clk);
            start_channel2 = 1;
            @(posedge clk);
            start_channel2 = 0;

            wait(done_channel2 == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Concurrent transfers (CH1=4, CH2=8)");
            reset_dut();
            bytes_to_transfer1 = 8'd4;
            bytes_to_transfer2 = 8'd8;

            @(posedge clk);
            start_channel1 = 1;
            start_channel2 = 1;
            @(posedge clk);
            start_channel1 = 0;
            start_channel2 = 0;


            wait(done_channel1 == 1'b1 && done_channel2 == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Minimum size transfer (1 byte)");
            reset_dut();
            bytes_to_transfer1 = 8'd1;

            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;

            wait(done_channel1 == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Maximum size transfer (255 bytes)");
            reset_dut();
            bytes_to_transfer2 = 8'd255;

            @(posedge clk);
            start_channel2 = 1;
            @(posedge clk);
            start_channel2 = 0;


            wait(done_channel2 == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Back-to-back transfers on Channel 1");
            reset_dut();


            bytes_to_transfer1 = 8'd3;
            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;
            wait(done_channel1 == 1'b1);


            @(posedge clk);


            bytes_to_transfer1 = 8'd2;
            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;
            wait(done_channel1 == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
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
        input expected_done_channel1;
        input expected_done_channel2;
        begin
            if (expected_done_channel1 === (expected_done_channel1 ^ done_channel1 ^ expected_done_channel1) &&
                expected_done_channel2 === (expected_done_channel2 ^ done_channel2 ^ expected_done_channel2)) begin
                $display("PASS");
                $display("  Outputs: done_channel1=%b, done_channel2=%b",
                         done_channel1, done_channel2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done_channel1=%b, done_channel2=%b",
                         expected_done_channel1, expected_done_channel2);
                $display("  Got:      done_channel1=%b, done_channel2=%b",
                         done_channel1, done_channel2);
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
        $dumpvars(0,bytes_to_transfer1, bytes_to_transfer2, clk, reset, start_channel1, start_channel2, done_channel1, done_channel2);
    end

endmodule
