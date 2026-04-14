`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] x;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
        .rst(rst),
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
            rst = 1;
            x = 0;
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
            $display("\nTest Case %0d: Impulse Response", test_num);
            reset_dut();

            x = 4'd1; @(posedge clk); #1;
            x = 4'd0; @(posedge clk); #1;
            x = 4'd0; @(posedge clk); #1;
            x = 4'd0; @(posedge clk); #1;

            #1;


            check_outputs(4'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Step Response (Constant 1s)", test_num);
            reset_dut();

            x = 4'd1; @(posedge clk); #1;
            x = 4'd1; @(posedge clk); #1;
            x = 4'd1; @(posedge clk); #1;
            x = 4'd1; @(posedge clk); #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Values (Overflow Truncation)", test_num);
            reset_dut();

            x = 4'd15; @(posedge clk); #1;
            x = 4'd15; @(posedge clk); #1;
            x = 4'd15; @(posedge clk); #1;
            x = 4'd15; @(posedge clk); #1;

            #1;


            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Pattern", test_num);
            reset_dut();

            x = 4'd1; @(posedge clk); #1;
            x = 4'd2; @(posedge clk); #1;
            x = 4'd1; @(posedge clk); #1;
            x = 4'd2; @(posedge clk); #1;

            #1;


            check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Input", test_num);
            reset_dut();

            x = 4'd0; @(posedge clk); #1;
            x = 4'd0; @(posedge clk); #1;
            x = 4'd0; @(posedge clk); #1;
            x = 4'd0; @(posedge clk); #1;

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shifting Window Check", test_num);
            reset_dut();

            x = 4'd2; @(posedge clk); #1;
            x = 4'd0; @(posedge clk); #1;
            x = 4'd0; @(posedge clk); #1;
            x = 4'd0; @(posedge clk); #1;
            x = 4'd1; @(posedge clk); #1;

            #1;


            check_outputs(4'd9);
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
        input [3:0] expected_y;
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
        $dumpvars(0,clk, rst, x, y);
    end

endmodule
