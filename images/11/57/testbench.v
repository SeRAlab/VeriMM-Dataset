`timescale 1ns/1ps

module perceptron_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] threshold;
    reg [7:0] w1;
    reg [7:0] w2;
    reg [7:0] w3;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    perceptron dut (
        .clk(clk),
        .threshold(threshold),
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x1 = 0; x2 = 0; x3 = 0;
            w1 = 0; w2 = 0; w3 = 0;
            threshold = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: All zeros", test_num);
            x1 = 0; x2 = 0; x3 = 0;
            w1 = 0; w2 = 0; w3 = 0;
            threshold = 10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single input exceeds threshold", test_num);
            x1 = 8'd10; w1 = 8'd5;
            x2 = 0;    w2 = 0;
            x3 = 0;    w3 = 0;
            threshold = 8'd40;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sum equals threshold", test_num);
            x1 = 8'd10; w1 = 8'd2;
            x2 = 0;    w2 = 0;
            x3 = 0;    w3 = 0;
            threshold = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple inputs cumulative exceed", test_num);
            x1 = 8'd5;  w1 = 8'd2;
            x2 = 8'd5;  w2 = 8'd2;
            x3 = 8'd5;  w3 = 8'd2;
            threshold = 8'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large input values", test_num);
            x1 = 8'd200; w1 = 8'd2;
            x2 = 8'd100; w2 = 8'd1;
            x3 = 8'd50;  w3 = 8'd1;
            threshold = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero weights, high inputs", test_num);
            x1 = 8'hFF; w1 = 8'd0;
            x2 = 8'hFF; w2 = 8'd0;
            x3 = 8'hFF; w3 = 8'd0;
            threshold = 8'd1;
            @(posedge clk);
            #1;
            #1;

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
        $display("perceptron Testbench");
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
        input expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
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
        $dumpvars(0,clk, threshold, w1, w2, w3, x1, x2, x3, y);
    end

endmodule
