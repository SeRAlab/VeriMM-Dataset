`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] signal;
    wire zero_cross;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .signal(signal),
        .zero_cross(zero_cross)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive crossing (-10 to 10)", test_num);

        rst_n = 0; signal = 16'shFFF6;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);

        signal = 16'sh000A;
        @(posedge clk);

        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative crossing (10 to -10)", test_num);

        rst_n = 0; signal = 16'sh000A;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);

        signal = 16'shFFF6;
        @(posedge clk);

        #2 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive crossing via Zero (-5 to 0)", test_num);
        rst_n = 0; signal = 16'shFFFB;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
        signal = 16'sh0000;
        @(posedge clk);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative crossing starting from Zero (0 to -5)", test_num);
        rst_n = 0; signal = 16'sh0000;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
        signal = 16'shFFFB;
        @(posedge clk);
        #2 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Extreme values Positive crossing (-32768 to 32767)", test_num);
        rst_n = 0; signal = 16'sh8000;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
        signal = 16'sh7FFF;
        @(posedge clk);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Extreme values Negative crossing (32767 to -32768)", test_num);
        rst_n = 0; signal = 16'sh7FFF;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
        signal = 16'sh8000;
        @(posedge clk);
        #2 #1;
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
        $display("zero_crossing_detector Testbench");
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
        input expected_zero_cross;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_zero_cross === (expected_zero_cross ^ zero_cross ^ expected_zero_cross)) begin
                $display("PASS");
                $display("  Outputs: zero_cross=%b",
                         zero_cross);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zero_cross=%b",
                         expected_zero_cross);
                $display("  Got:      zero_cross=%b",
                         zero_cross);
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

endmodule
