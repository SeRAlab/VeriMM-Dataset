`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [1:0] select;
    reg valid;
    wire [3:0] channel_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .rst(rst),
        .select(select),
        .valid(valid),
        .channel_ack(channel_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            select = 0;
            valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Channel 0 Select");
            reset_dut();
            select = 2'b00;
            valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Channel 1 Select");
            reset_dut();
            select = 2'b01;
            valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Channel 2 Select");
            reset_dut();
            select = 2'b10;
            valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Channel 3 Select");
            reset_dut();
            select = 2'b11;
            valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Valid Low");
            reset_dut();
            select = 2'b10;
            valid = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Channel Switching");
            reset_dut();
            select = 2'b00;
            valid = 1'b1;
            @(posedge clk);
            select = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Reset Priority");
            rst = 1;
            select = 2'b01;
            valid = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Toggle Valid");
            reset_dut();
            select = 2'b01;
            valid = 1'b1;
            @(posedge clk);
            valid = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_channel_ack;
        begin
            if (expected_channel_ack === (expected_channel_ack ^ channel_ack ^ expected_channel_ack)) begin
                $display("PASS");
                $display("  Outputs: channel_ack=%h",
                         channel_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel_ack=%h",
                         expected_channel_ack);
                $display("  Got:      channel_ack=%h",
                         channel_ack);
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
        $dumpvars(0,clk, rst, select, valid, channel_ack);
    end

endmodule
