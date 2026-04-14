`timescale 1ns/1ps

module chebyshev_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg [7:0] x;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chebyshev_filter dut (
        .clk(clk),
        .ctrl(ctrl),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ctrl = 0;
            x = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bypass Mode (ctrl=0) - Value 0xA5", test_num);
            reset_dut();
            ctrl = 0;
            x = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bypass Mode (ctrl=0) - Value 0xFF", test_num);
            reset_dut();
            ctrl = 0;
            x = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Filter Mode (ctrl=1) - Steady State Zero", test_num);
            reset_dut();
            ctrl = 1;
            x = 8'h00;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bypass Mode Sequence", test_num);
            reset_dut();
            ctrl = 0;
            x = 8'h11; @(posedge clk);
            x = 8'h22; @(posedge clk);
            x = 8'h33; @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Filter Mode (ctrl=1) - DC Step 0x80", test_num);
            reset_dut();
            ctrl = 1;
            x = 8'h80;
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mode Switch (Filter to Bypass)", test_num);
            reset_dut();
            ctrl = 1;
            x = 8'hFF;
            repeat(5) @(posedge clk);
            ctrl = 0;
            x = 8'h5A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chebyshev_filter Testbench");
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
        input [7:0] expected_y;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, ctrl, x, y);
    end

endmodule
