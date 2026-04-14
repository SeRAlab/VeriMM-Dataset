`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] noisy_signal;
    reg rst;
    wire [7:0] clean_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .clk(clk),
        .noisy_signal(noisy_signal),
        .rst(rst),
        .clean_signal(clean_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            noisy_signal = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Valid Stable Signal", test_num);
            reset_dut();
            noisy_signal = 8'hA5;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Suppression of Short Glitch", test_num);
            reset_dut();


            noisy_signal = 8'hAA;
            repeat(5) @(posedge clk);


            noisy_signal = 8'hFF;
            repeat(2) @(posedge clk);


            noisy_signal = 8'hAA;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Constant Noise Suppression", test_num);
            reset_dut();


            noisy_signal = 8'h55;
            repeat(5) @(posedge clk);


            noisy_signal = 8'h11; @(posedge clk);
            noisy_signal = 8'h22; @(posedge clk);
            noisy_signal = 8'h33; @(posedge clk);
            noisy_signal = 8'h44; @(posedge clk);
            noisy_signal = 8'h11; @(posedge clk);


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Transition Between Stable States", test_num);
            reset_dut();


            noisy_signal = 8'h12;
            repeat(5) @(posedge clk);


            noisy_signal = 8'h34;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h34);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Signal Just Below Threshold", test_num);
            reset_dut();


            noisy_signal = 8'h11;
            repeat(5) @(posedge clk);


            noisy_signal = 8'hEE;
            repeat(2) @(posedge clk);


            noisy_signal = 8'h00;
            @(posedge clk);


            #1;



            check_outputs(8'h11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("noise_suppression Testbench");
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
        input [7:0] expected_clean_signal;
        begin
            if (expected_clean_signal === (expected_clean_signal ^ clean_signal ^ expected_clean_signal)) begin
                $display("PASS");
                $display("  Outputs: clean_signal=%h",
                         clean_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clean_signal=%h",
                         expected_clean_signal);
                $display("  Got:      clean_signal=%h",
                         clean_signal);
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
        $dumpvars(0,clk, noisy_signal, rst, clean_signal);
    end

endmodule
