`timescale 1ns/1ps

module rc_oscillator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] freq;
    reg reset;
    wire square_wave;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rc_oscillator dut (
        .clk(clk),
        .freq(freq),
        .reset(reset),
        .square_wave(square_wave)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            freq = 4'd0;
            #20;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing freq = 2", test_num);
            reset_dut();
            freq = 4'd2;


            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing freq = 4", test_num);
            reset_dut();
            freq = 4'd4;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing freq = 0", test_num);
            reset_dut();
            freq = 4'd0;




            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Testing freq = 15", test_num);
            reset_dut();
            freq = 4'd15;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verifying Reset State", test_num);

            freq = 4'd2;
            repeat(10) @(posedge clk);


            reset = 1;
            #20;

            #1;


            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rc_oscillator Testbench");
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
        input expected_square_wave;
        begin
            if (expected_square_wave === (expected_square_wave ^ square_wave ^ expected_square_wave)) begin
                $display("PASS");
                $display("  Outputs: square_wave=%b",
                         square_wave);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: square_wave=%b",
                         expected_square_wave);
                $display("  Got:      square_wave=%b",
                         square_wave);
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
        $dumpvars(0,clk, freq, reset, square_wave);
    end

endmodule
