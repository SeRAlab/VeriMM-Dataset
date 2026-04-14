`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg [15:0] reference_signal;
    reg rst;
    wire [15:0] processed_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .audio_in(audio_in),
        .clk(clk),
        .reference_signal(reference_signal),
        .rst(rst),
        .processed_signal(processed_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            audio_in = 16'd0;
            reference_signal = 16'd0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Inputs", test_num);
            reset_dut();

            audio_in = 16'h0000;
            reference_signal = 16'h0000;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Signal with No Echo", test_num);
            reset_dut();

            audio_in = 16'h1234;
            reference_signal = 16'h0000;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Perfect Echo Cancellation", test_num);
            reset_dut();

            audio_in = 16'hAAAA;
            reference_signal = 16'hAAAA;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Standard Cancellation", test_num);
            reset_dut();

            audio_in = 16'h5555;
            reference_signal = 16'h1111;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h4444);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Range Cancellation", test_num);
            reset_dut();

            audio_in = 16'hFFFF;
            reference_signal = 16'h0001;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Underflow Scenario", test_num);
            reset_dut();

            audio_in = 16'h0010;
            reference_signal = 16'h0020;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'hFFF0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_cancellation Testbench");
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
        input [15:0] expected_processed_signal;
        begin
            if (expected_processed_signal === (expected_processed_signal ^ processed_signal ^ expected_processed_signal)) begin
                $display("PASS");
                $display("  Outputs: processed_signal=%h",
                         processed_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: processed_signal=%h",
                         expected_processed_signal);
                $display("  Got:      processed_signal=%h",
                         processed_signal);
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
        $dumpvars(0,audio_in, clk, reference_signal, rst, processed_signal);
    end

endmodule
