`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address_channel1;
    reg [7:0] address_channel2;
    reg clk;
    reg [15:0] data_in_channel1;
    reg [15:0] data_in_channel2;
    reg reset;
    reg start_channel1;
    reg start_channel2;
    wire channel_busy;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .address_channel1(address_channel1),
        .address_channel2(address_channel2),
        .clk(clk),
        .data_in_channel1(data_in_channel1),
        .data_in_channel2(data_in_channel2),
        .reset(reset),
        .start_channel1(start_channel1),
        .start_channel2(start_channel2),
        .channel_busy(channel_busy),
        .data_out(data_out)
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
            address_channel1 = 8'h0;
            address_channel2 = 8'h0;
            data_in_channel1 = 16'h0;
            data_in_channel2 = 16'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Channel 1 Transfer", test_num);
            reset_dut();

            address_channel1 = 8'hAA;
            data_in_channel1 = 16'h1234;
            start_channel1 = 1;

            @(posedge clk);
            #1 start_channel1 = 0;


            @(posedge clk);
            #1;

            check_outputs(0, 16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Channel 2 Transfer", test_num);
            reset_dut();

            address_channel2 = 8'hBB;
            data_in_channel2 = 16'h5678;
            start_channel2 = 1;

            @(posedge clk);
            #1 start_channel2 = 0;

            @(posedge clk);
            #1;

            check_outputs(0, 16'h5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sequential Transfers CH1 then CH2", test_num);
            reset_dut();


            address_channel1 = 8'h01;
            data_in_channel1 = 16'hAAAA;
            start_channel1 = 1;
            @(posedge clk);
            #1 start_channel1 = 0;
            @(posedge clk);


            address_channel2 = 8'h02;
            data_in_channel2 = 16'hBBBB;
            start_channel2 = 1;
            @(posedge clk);
            #1 start_channel2 = 0;
            @(posedge clk);


            #1;



            check_outputs(0, 16'hBBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Simultaneous Start Signals", test_num);
            reset_dut();

            address_channel1 = 8'h11;
            data_in_channel1 = 16'hC0DE;
            address_channel2 = 8'h22;
            data_in_channel2 = 16'hBEEF;

            start_channel1 = 1;
            start_channel2 = 1;

            @(posedge clk);
            #1;
            start_channel1 = 0;
            start_channel2 = 0;

            @(posedge clk);


            if (data_out == 16'hC0DE || data_out == 16'hBEEF) begin
                #1;

                check_outputs(0, data_out);
            end else begin
                #1;

                check_outputs(0, 16'hC0DE);
            end
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
        input expected_channel_busy;
        input [15:0] expected_data_out;
        begin
            if (expected_channel_busy === (expected_channel_busy ^ channel_busy ^ expected_channel_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: channel_busy=%b, data_out=%h",
                         channel_busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel_busy=%b, data_out=%h",
                         expected_channel_busy, expected_data_out);
                $display("  Got:      channel_busy=%b, data_out=%h",
                         channel_busy, data_out);
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
        $dumpvars(0,address_channel1, address_channel2, clk, data_in_channel1, data_in_channel2, reset, start_channel1, start_channel2, channel_busy, data_out);
    end

endmodule
