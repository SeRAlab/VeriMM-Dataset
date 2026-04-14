`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_signal;
    reg rst;
    wire echo_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .current_signal(current_signal),
        .rst(rst),
        .echo_detected(echo_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            current_signal = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Non-matching sequence", test_num);
            reset_dut();

            current_signal = 8'hAA;
            @(posedge clk);
            #1;

            current_signal = 8'hBB;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matching sequence (Echo)", test_num);
            reset_dut();

            current_signal = 8'h55;
            @(posedge clk);
            #1;

            current_signal = 8'h55;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Recovery from non-echo to echo", test_num);
            reset_dut();

            current_signal = 8'h11;
            @(posedge clk);
            #1;

            current_signal = 8'h22;
            @(posedge clk);
            #1;

            current_signal = 8'h22;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset clears stored signal", test_num);
            reset_dut();

            current_signal = 8'hFF;
            @(posedge clk);
            #1;


            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;

            current_signal = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero signal echo", test_num);
            reset_dut();

            current_signal = 8'h00;
            @(posedge clk);
            #1;

            current_signal = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple transitions", test_num);
            reset_dut();

            current_signal = 8'hA1;
            @(posedge clk); #1;
            current_signal = 8'hB2;
            @(posedge clk); #1;
            current_signal = 8'hC3;
            @(posedge clk); #1;
            current_signal = 8'hC3;
            @(posedge clk); #1;
            current_signal = 8'hD4;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b0);
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
        input expected_echo_detected;
        begin
            if (expected_echo_detected === (expected_echo_detected ^ echo_detected ^ expected_echo_detected)) begin
                $display("PASS");
                $display("  Outputs: echo_detected=%b",
                         echo_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: echo_detected=%b",
                         expected_echo_detected);
                $display("  Got:      echo_detected=%b",
                         echo_detected);
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
        $dumpvars(0,clk, current_signal, rst, echo_detected);
    end

endmodule
