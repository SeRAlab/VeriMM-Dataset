`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg enable;
    reg reset;
    wire busy;
    wire [2:0] channel_out;

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
        .busy(busy),
        .channel_out(channel_out)
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
            channel_select = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Select Channel 0", test_num);
            reset_dut();
            enable = 1;
            channel_select = 3'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Select Channel 7", test_num);
            reset_dut();
            enable = 1;
            channel_select = 3'd7;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Select Channel 4", test_num);
            reset_dut();
            enable = 1;
            channel_select = 3'd4;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Controller Disabled", test_num);
            reset_dut();
            enable = 0;
            channel_select = 3'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(0, channel_out);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Switch Channel Mid-Operation", test_num);
            reset_dut();
            enable = 1;
            channel_select = 3'd1;
            @(posedge clk);
            channel_select = 3'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 3'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Reset Override", test_num);
            reset_dut();
            enable = 1;
            channel_select = 3'd3;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 3'b000);
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
        input expected_busy;
        input [2:0] expected_channel_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_channel_out === (expected_channel_out ^ channel_out ^ expected_channel_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, channel_out=%h",
                         busy, channel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, channel_out=%h",
                         expected_busy, expected_channel_out);
                $display("  Got:      busy=%b, channel_out=%h",
                         busy, channel_out);
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
        $dumpvars(0,channel_select, clk, enable, reset, busy, channel_out);
    end

endmodule
