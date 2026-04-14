`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_addr;
    reg clk;
    reg reset;
    reg start;
    wire [7:0] active_channel;
    wire complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_addr(channel_addr),
        .clk(clk),
        .reset(reset),
        .start(start),
        .active_channel(active_channel),
        .complete(complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            channel_addr = 3'b000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Channel 0 Select", test_num);
            reset_dut();
            channel_addr = 3'd0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(complete == 1'b1);
            #1;

            check_outputs(8'b0000_0001, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Channel 1 Select", test_num);
            reset_dut();
            channel_addr = 3'd1;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(complete == 1'b1);
            #1;

            check_outputs(8'b0000_0010, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Channel 2 Select", test_num);
            reset_dut();
            channel_addr = 3'd2;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(complete == 1'b1);
            #1;

            check_outputs(8'b0000_0100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Channel 3 Select", test_num);
            reset_dut();
            channel_addr = 3'd3;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(complete == 1'b1);
            #1;

            check_outputs(8'b0000_1000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Channel 4 Select", test_num);
            reset_dut();
            channel_addr = 3'd4;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(complete == 1'b1);
            #1;

            check_outputs(8'b0001_0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Channel 5 Select", test_num);
            reset_dut();
            channel_addr = 3'd5;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(complete == 1'b1);
            #1;

            check_outputs(8'b0010_0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Channel 6 Select", test_num);
            reset_dut();
            channel_addr = 3'd6;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(complete == 1'b1);
            #1;

            check_outputs(8'b0100_0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Channel 7 Select", test_num);
            reset_dut();
            channel_addr = 3'd7;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(complete == 1'b1);
            #1;

            check_outputs(8'b1000_0000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Idle State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'b0000_0000, 1'b0);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [7:0] expected_active_channel;
        input expected_complete;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_complete === (expected_complete ^ complete ^ expected_complete)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, complete=%b",
                         active_channel, complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, complete=%b",
                         expected_active_channel, expected_complete);
                $display("  Got:      active_channel=%h, complete=%b",
                         active_channel, complete);
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
        $dumpvars(0,channel_addr, clk, reset, start, active_channel, complete);
    end

endmodule
