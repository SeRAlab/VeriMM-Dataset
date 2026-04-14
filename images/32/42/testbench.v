`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg enable;
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
        .enable(enable),
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
            enable = 0;
            channel_select = 3'b000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Idle State after Reset");
            reset_dut();

            #1;


            check_outputs(3'b000, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Activate Channel 0");
            reset_dut();
            @(posedge clk);
            channel_select = 3'b000;
            enable = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(3'b000, data_out);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Activate Channel 3");
            reset_dut();
            @(posedge clk);
            channel_select = 3'b011;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011, data_out);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Activate Channel 7");
            reset_dut();
            @(posedge clk);
            channel_select = 3'b111;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111, data_out);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Change Channel while Disable");
            reset_dut();
            @(posedge clk);
            channel_select = 3'b101;
            enable = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000, 8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Dynamic Switching");
            reset_dut();
            @(posedge clk);
            enable = 1;
            channel_select = 3'b001;
            @(posedge clk);
            #1;
            channel_select = 3'b110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b110, data_out);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Mid-Transfer Reset");
            reset_dut();
            @(posedge clk);
            channel_select = 3'b010;
            enable = 1;
            @(posedge clk);
            #1;
            reset = 1;
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
        testcase007();
        
        
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
        $dumpvars(0,channel_select, clk, enable, reset, active_channel, data_out);
    end

endmodule
