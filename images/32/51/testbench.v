`timescale 1ns/1ps

module rnn_inference_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [4:0] x;
    wire [4:0] h;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_inference dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .h(h)
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
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic powers of 2 sequence", test_num);
            reset_dut();

            x = 5'h01; @(negedge clk);
            x = 5'h02; @(negedge clk);
            x = 5'h04; @(negedge clk);

            #1;


            check_outputs(5'h07);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: XOR self-cancellation", test_num);
            reset_dut();

            x = 5'h1F; @(negedge clk);
            x = 5'h1F; @(negedge clk);

            #1;


            check_outputs(5'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns", test_num);
            reset_dut();

            x = 5'h0A; @(negedge clk);
            x = 5'h15; @(negedge clk);

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero input sequence", test_num);
            reset_dut();

            x = 5'h12; @(negedge clk);
            x = 5'h00; @(negedge clk);
            x = 5'h00; @(negedge clk);

            #1;


            check_outputs(5'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-step calculation", test_num);
            reset_dut();

            x = 5'h11; @(negedge clk);
            x = 5'h0E; @(negedge clk);
            x = 5'h1F; @(negedge clk);
            x = 5'h05; @(negedge clk);

            #1;


            check_outputs(5'h05);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Accumulating bits 0 through 4", test_num);
            reset_dut();

            x = 5'h01; @(negedge clk);
            x = 5'h02; @(negedge clk);
            x = 5'h04; @(negedge clk);
            x = 5'h08; @(negedge clk);
            x = 5'h10; @(negedge clk);

            #1;


            check_outputs(5'h1F);
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
        input [4:0] expected_h;
        begin
            if (expected_h === (expected_h ^ h ^ expected_h)) begin
                $display("PASS");
                $display("  Outputs: h=%h",
                         h);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%h",
                         expected_h);
                $display("  Got:      h=%h",
                         h);
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
        $dumpvars(0,clk, rst, x, h);
    end

endmodule
