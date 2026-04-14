`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] x;
    wire [5:0] y;

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
        $display("Test Case 001: Impulse Input");
        rst_n = 0; x = 0; @(posedge clk);
        rst_n = 1; x = 4; @(posedge clk);
        x = 0; @(posedge clk);
        x = 0; @(posedge clk);
        x = 0; @(posedge clk);
        x = 0; @(posedge clk);
        #1;

        check_outputs(6'd4);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Constant Input (2)");
        rst_n = 0; x = 0; @(posedge clk);
        rst_n = 1;
        repeat(5) begin
            x = 2; @(posedge clk);
        end
        #1;

        check_outputs(6'd18);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Ramp Input");
        rst_n = 0; x = 0; @(posedge clk);
        rst_n = 1;
        x = 1; @(posedge clk);
        x = 2; @(posedge clk);
        x = 3; @(posedge clk);
        x = 4; @(posedge clk);
        x = 5; @(posedge clk);
        #1;

        check_outputs(6'd27);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Maximum Scale Input (7)");
        rst_n = 0; x = 0; @(posedge clk);
        rst_n = 1;
        repeat(5) begin
            x = 7; @(posedge clk);
        end
        #1;

        check_outputs(6'd63);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Zero Flush");
        rst_n = 0; x = 0; @(posedge clk);
        rst_n = 1;
        x = 15; @(posedge clk);
        x = 15; @(posedge clk);
        repeat(5) begin
            x = 0; @(posedge clk);
        end
        #1;

        check_outputs(6'd0);
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
        input [5:0] expected_y;
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
