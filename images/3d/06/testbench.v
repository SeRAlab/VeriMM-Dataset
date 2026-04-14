`timescale 1ns/1ps

module rnn_inference_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] x;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_inference dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Sequence", test_num);
            reset_dut();

            x = 8'd0; @(posedge clk); #1;
            x = 8'd0; @(posedge clk); #1;
            x = 8'd0; @(posedge clk); #1;
            x = 8'd0; @(posedge clk); #1;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Constant Small Values", test_num);
            reset_dut();

            x = 8'd1; @(posedge clk); #1;
            x = 8'd1; @(posedge clk); #1;
            x = 8'd1; @(posedge clk); #1;
            x = 8'd1; @(posedge clk); #1;

            #1;


            check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Varying Values", test_num);
            reset_dut();

            x = 8'd10; @(posedge clk); #1;
            x = 8'd20; @(posedge clk); #1;
            x = 8'd30; @(posedge clk); #1;
            x = 8'd40; @(posedge clk); #1;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Check", test_num);
            reset_dut();

            x = 8'd100; @(posedge clk); #1;
            x = 8'd100; @(posedge clk); #1;
            x = 8'd100; @(posedge clk); #1;
            x = 8'd100; @(posedge clk); #1;

            #1;


            check_outputs(8'h90);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Values", test_num);
            reset_dut();

            x = 8'd255; @(posedge clk); #1;
            x = 8'd1;   @(posedge clk); #1;
            x = 8'd128; @(posedge clk); #1;
            x = 8'd127; @(posedge clk); #1;

            #1;


            check_outputs(8'hFF);
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
        input [7:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, reset, x, y);
    end

endmodule
