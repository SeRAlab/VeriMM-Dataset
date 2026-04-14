`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [2:0] active_channel;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .active_channel(active_channel),
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
            channel_select = 3'b000;
            data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 1", test_num);
            reset_dut();
            channel_select = 3'd1;
            data_in = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 7 (Max)", test_num);
            reset_dut();
            channel_select = 3'd7;
            data_in = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd7, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 0", test_num);
            reset_dut();
            channel_select = 3'd0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 4", test_num);
            reset_dut();
            channel_select = 3'd4;
            data_in = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd4, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Channel Transition", test_num);
            reset_dut();


            channel_select = 3'd2;
            data_in = 8'h22;
            @(posedge clk);


            #1;
            channel_select = 3'd6;
            data_in = 8'h66;
            @(posedge clk);

            #1;
            #1;

            check_outputs(3'd6, 8'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Priority", test_num);
            reset_dut();


            channel_select = 3'd3;
            data_in = 8'hCC;
            @(posedge clk);


            #1 reset = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(3'b000, 8'h00);
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
        input [2:0] expected_active_channel;
        input [7:0] expected_data_out;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, data_out=%h",
                         active_channel, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, data_out=%h",
                         expected_active_channel, expected_data_out);
                $display("  Got:      active_channel=%h, data_out=%h",
                         active_channel, data_out);
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
        $dumpvars(0,channel_select, clk, data_in, reset, active_channel, data_out);
    end

endmodule
