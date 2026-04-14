`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] x;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
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
            x <= 32'h0;
            repeat(NUM_TAPS + 1) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Zero Input...");
            test_num = test_num + 1;
            reset_dut();

            x <= 32'h0;
            repeat(10) @(posedge clk);

            #1;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Impulse Response...");
            test_num = test_num + 1;
            reset_dut();

            x <= 32'h1;
            @(posedge clk);
            x <= 32'h0;
            repeat(NUM_TAPS - 1) @(posedge clk);

            #1;


            #1;



            check_outputs(32'h1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Step Response...");
            test_num = test_num + 1;
            reset_dut();

            x <= 32'h1;
            repeat(NUM_TAPS) @(posedge clk);

            #1;

            #1;


            check_outputs(32'd32);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Scaled Input...");
            test_num = test_num + 1;
            reset_dut();

            x <= 32'h2;
            repeat(NUM_TAPS) @(posedge clk);

            #1;

            #1;


            check_outputs(32'd64);
        end
        endtask

    task testcase005;

        integer k;
        begin
            $display("Running testcase005: Alternating Sequence...");
            test_num = test_num + 1;
            reset_dut();

            for (k = 0; k < NUM_TAPS; k = k + 1) begin
                x <= (k % 2 == 0) ? 32'h1 : 32'h0;
                @(posedge clk);
            end

            #1;


            #1;



            check_outputs(32'd16);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
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
        input [31:0] expected_y;
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
        $dumpvars(0,clk, x, y);
    end

endmodule
