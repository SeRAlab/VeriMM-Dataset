`timescale 1ns/1ps

module wifi_signal_indicator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] signal_strength;
    wire [2:0] strength_category;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_signal_indicator dut (
        .clk(clk),
        .signal_strength(signal_strength),
        .strength_category(strength_category)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            signal_strength = 8'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum Weak Signal", test_num);
            reset_dut();
            signal_strength = 8'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Weak Signal", test_num);
            reset_dut();
            signal_strength = 8'd84;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum Moderate Signal", test_num);
            reset_dut();
            signal_strength = 8'd85;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid Moderate Signal", test_num);
            reset_dut();
            signal_strength = 8'd127;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Moderate Signal", test_num);
            reset_dut();
            signal_strength = 8'd169;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum Strong Signal", test_num);
            reset_dut();
            signal_strength = 8'd170;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid Strong Signal", test_num);
            reset_dut();
            signal_strength = 8'd212;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Strong Signal", test_num);
            reset_dut();
            signal_strength = 8'd255;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_signal_indicator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [2:0] expected_strength_category;
        begin
            if (expected_strength_category === (expected_strength_category ^ strength_category ^ expected_strength_category)) begin
                $display("PASS");
                $display("  Outputs: strength_category=%h",
                         strength_category);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strength_category=%h",
                         expected_strength_category);
                $display("  Got:      strength_category=%h",
                         strength_category);
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
        $dumpvars(0,clk, signal_strength, strength_category);
    end

endmodule
