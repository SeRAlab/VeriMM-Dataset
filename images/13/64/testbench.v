`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Verification", test_num);
        rst = 1;
        x = 8'hFF;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
        rst = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Impulse Response (First Tap)", test_num);
        rst = 1; @(posedge clk); rst = 0;
        x = 8'd1;
        @(posedge clk);
        x = 8'd0;
        #1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Step Response (DC Gain)", test_num);
        rst = 1; @(posedge clk); rst = 0;
        x = 8'd1;
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Flush Delay Line", test_num);
        rst = 1; @(posedge clk); rst = 0;
        x = 8'd10;
        repeat(8) @(posedge clk);
        x = 8'd0;
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Scaled Input Check", test_num);
        rst = 1; @(posedge clk); rst = 0;
        x = 8'd10;
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(8'd80);
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
