`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] echo_signal;
    reg [15:0] original_signal;
    reg rst;
    wire [15:0] cleaned_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .clk(clk),
        .echo_signal(echo_signal),
        .original_signal(original_signal),
        .rst(rst),
        .cleaned_signal(cleaned_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            echo_signal = 0;
            original_signal = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Subtraction (100 - 30)", test_num);
            reset_dut();
            original_signal = 16'd100;
            echo_signal = 16'd30;
            @(posedge clk);
            #2 #1;
 check_outputs(16'd70);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Signal with Echo (0 - 50)", test_num);
            reset_dut();
            original_signal = 16'd0;
            echo_signal = 16'd50;
            @(posedge clk);

            #2 #1;
 check_outputs(16'hFFCE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Original signal with no echo", test_num);
            reset_dut();
            original_signal = 16'h1234;
            echo_signal = 16'h0000;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signal equals Echo", test_num);
            reset_dut();
            original_signal = 16'hABCD;
            echo_signal = 16'hABCD;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum values", test_num);
            reset_dut();
            original_signal = 16'hFFFF;
            echo_signal = 16'h0001;
            @(posedge clk);
            #2 #1;
 check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Data Stream", test_num);
            reset_dut();


            original_signal = 16'd500;
            echo_signal = 16'd100;
            @(posedge clk);
            #1;


            original_signal = 16'd1000;
            echo_signal = 16'd200;
            @(posedge clk);
            #2 #1;
 check_outputs(16'd800);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();
            original_signal = 16'hAAAA;
            echo_signal = 16'h1111;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(16'h0000);
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
        input [15:0] expected_cleaned_signal;
        begin
            if (expected_cleaned_signal === (expected_cleaned_signal ^ cleaned_signal ^ expected_cleaned_signal)) begin
                $display("PASS");
                $display("  Outputs: cleaned_signal=%h",
                         cleaned_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cleaned_signal=%h",
                         expected_cleaned_signal);
                $display("  Got:      cleaned_signal=%h",
                         cleaned_signal);
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
        $dumpvars(0,clk, echo_signal, original_signal, rst, cleaned_signal);
    end

endmodule
