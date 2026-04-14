`timescale 1ns/1ps

module wifi_signal_strength_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] signal_strength;
    wire [2:0] strength_category;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_signal_strength dut (
        .clk(clk),
        .rst(rst),
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
            rst = 1;
            signal_strength = 0;
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
            $display("Test Case %0d: Very Weak Signal (-90 dBm)", test_num);
            reset_dut();
            signal_strength = -8'sd90;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Weak Signal Lower Boundary (-80 dBm)", test_num);
            reset_dut();
            signal_strength = -8'sd80;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Weak Signal Mid-Range (-75 dBm)", test_num);
            reset_dut();
            signal_strength = -8'sd75;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Moderate Signal Lower Boundary (-70 dBm)", test_num);
            reset_dut();
            signal_strength = -8'sd70;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Moderate Signal Mid-Range (-65 dBm)", test_num);
            reset_dut();
            signal_strength = -8'sd65;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Strong Signal Lower Boundary (-60 dBm)", test_num);
            reset_dut();
            signal_strength = -8'sd60;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Strong Signal Mid-Range (-55 dBm)", test_num);
            reset_dut();
            signal_strength = -8'sd55;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b011);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Very Strong Signal Lower Boundary (-50 dBm)", test_num);
            reset_dut();
            signal_strength = -8'sd50;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Very Strong Signal (-20 dBm)", test_num);
            reset_dut();
            signal_strength = -8'sd20;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Typical Signal (0 dBm)", test_num);
            reset_dut();
            signal_strength = 8'sd0;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b100);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Extreme Low Signal (-128 dBm)", test_num);
            reset_dut();
            signal_strength = -8'sd128;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_signal_strength Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        $dumpvars(0,clk, rst, signal_strength, strength_category);
    end

endmodule
