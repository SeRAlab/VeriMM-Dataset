`timescale 1ns/1ps

module LMS_Filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg rst;
    reg [15:0] x;
    wire [15:0] error;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LMS_Filter dut (
        .clk(clk),
        .d(d),
        .rst(rst),
        .x(x),
        .error(error),
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
            x = 16'd0;
            d = 16'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cold Start (Initial Weights = 0)", test_num);
            reset_dut();
            x = 16'h0010;
            d = 16'h0050;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0050, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Input Signal", test_num);
            reset_dut();
            x = 16'h0000;
            d = 16'h1234;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Desired Signal", test_num);
            reset_dut();
            x = 16'h0005;
            d = 16'hFF9C;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFF9C, 16'h0000);
        end
        endtask

    task testcase005;

        reg [15:0] last_y;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Adaptation Movement Check", test_num);
            reset_dut();
            x = 16'h0001;
            d = 16'h00FF;


            repeat(10) @(posedge clk);
            #1;



            if (y != 16'h0000) begin
                $display("PASS: Filter is adapting (y changed from zero)");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter is stagnant (y stayed at zero)");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High Magnitude Signal", test_num);
            reset_dut();
            x = 16'h7FFF;
            d = 16'h8001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h8001, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LMS_Filter Testbench");
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
        input [15:0] expected_error;
        input [15:0] expected_y;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: error=%h, y=%h",
                         error, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%h, y=%h",
                         expected_error, expected_y);
                $display("  Got:      error=%h, y=%h",
                         error, y);
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
        $dumpvars(0,clk, d, rst, x, error, y);
    end

endmodule
