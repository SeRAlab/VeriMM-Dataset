`timescale 1ns/1ps

module multi_div_add_sub_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    wire [3:0] out0;
    wire [3:0] out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multi_div_add_sub dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .out0(out0),
        .out1(out1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in0 = 0;
            in1 = 0;
            in2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Positive Logic", test_num);
            in0 = 4'd2;
            in1 = 4'd8;
            in2 = 4'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd5, 4'd1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Truncation and Zero Result", test_num);
            in0 = 4'd4;
            in1 = 4'd12;
            in2 = 4'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd11, 4'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow and Underflow", test_num);
            in0 = 4'd7;
            in1 = 4'd4;
            in2 = 4'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Multi-overflow and Div-floor", test_num);
            in0 = 4'd10;
            in1 = 4'd3;
            in2 = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd4, 4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: High Underflow", test_num);
            in0 = 4'd1;
            in1 = 4'd0;
            in2 = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd1, 4'd11);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values", test_num);
            in0 = 4'd15;
            in1 = 4'd15;
            in2 = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd13, 4'd4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multi_div_add_sub Testbench");
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
        input [3:0] expected_out0;
        input [3:0] expected_out1;
        begin
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h",
                         out0, out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h",
                         expected_out0, expected_out1);
                $display("  Got:      out0=%h, out1=%h",
                         out0, out1);
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
        $dumpvars(0,clk, in0, in1, in2, out0, out1);
    end

endmodule
