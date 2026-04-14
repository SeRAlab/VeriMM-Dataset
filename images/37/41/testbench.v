`timescale 1ns/1ps

module FIR_Filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] x;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FIR_Filter dut (
        .clk(clk),
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
            x = 4'd0;


            repeat(4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: All Zeros", test_num);
            @(negedge clk) x = 4'd0;
            @(negedge clk) x = 4'd0;
            @(negedge clk) x = 4'd0;
            @(negedge clk) x = 4'd0;
            @(posedge clk); #2;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: All Ones", test_num);
            @(negedge clk) x = 4'd1;
            @(negedge clk) x = 4'd1;
            @(negedge clk) x = 4'd1;
            @(negedge clk) x = 4'd1;
            @(posedge clk); #2;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Maximum Input Values", test_num);
            @(negedge clk) x = 4'd15;
            @(negedge clk) x = 4'd15;
            @(negedge clk) x = 4'd15;
            @(negedge clk) x = 4'd15;
            @(posedge clk); #2;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Rising Sequence (1, 2, 3, 4)", test_num);
            @(negedge clk) x = 4'd1;
            @(negedge clk) x = 4'd2;
            @(negedge clk) x = 4'd3;
            @(negedge clk) x = 4'd4;
            @(posedge clk); #2;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Falling Sequence (4, 3, 2, 1)", test_num);
            @(negedge clk) x = 4'd4;
            @(negedge clk) x = 4'd3;
            @(negedge clk) x = 4'd2;
            @(negedge clk) x = 4'd1;
            @(posedge clk); #2;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Impulse Response (at 4th tap)", test_num);
            @(negedge clk) x = 4'd10;
            @(negedge clk) x = 4'd0;
            @(negedge clk) x = 4'd0;
            @(negedge clk) x = 4'd0;
            @(posedge clk); #2;
            #1;

            check_outputs(8'd40);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Impulse Response (at 1st tap)", test_num);
            @(negedge clk) x = 4'd0;
            @(negedge clk) x = 4'd0;
            @(negedge clk) x = 4'd0;
            @(negedge clk) x = 4'd10;
            @(posedge clk); #2;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Alternating Pattern", test_num);
            @(negedge clk) x = 4'd15;
            @(negedge clk) x = 4'd0;
            @(negedge clk) x = 4'd15;
            @(negedge clk) x = 4'd0;
            @(posedge clk); #2;
            #1;

            check_outputs(8'd90);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FIR_Filter Testbench");
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
        $dumpvars(0,clk, x, y);
    end

endmodule
