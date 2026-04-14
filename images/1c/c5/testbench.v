`timescale 1ns/1ps

module rnn_inference_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [4:0] x;
    wire [4:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_inference dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            x = 5'd2;
            @(posedge clk);
            #1;
            x = 5'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            x = 5'd5;
            @(posedge clk);
            #1;
            x = 5'd0;
            @(posedge clk);
            #1;
            x = 5'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd13);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            x = 5'd31;
            @(posedge clk);
            #1;
            x = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd28);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            x = 5'd10;
            @(posedge clk);
            #1;
            x = 5'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            x = 5'd1;
            @(posedge clk); #1;
            x = 5'd1;
            @(posedge clk); #1;
            x = 5'd1;
            @(posedge clk); #1;
            x = 5'd1;
            @(posedge clk); #1;
            #1;

            check_outputs(5'd8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_inference Testbench");
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
        input [4:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, rst, x, state);
    end

endmodule
