`timescale 1ns/1ps

module simple_nn_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input1;
    reg [7:0] input2;
    reg rst;
    wire output1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_nn dut (
        .clk(clk),
        .input1(input1),
        .input2(input2),
        .rst(rst),
        .output1(output1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input1 = 8'd0;
            input2 = 8'd0;
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
            $display("Test Case %03d: Inputs (0, 0)", test_num);
            reset_dut();
            input1 = 8'd0;
            input2 = 8'd0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Inputs (255, 255)", test_num);
            reset_dut();
            input1 = 8'd255;
            input2 = 8'd255;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Inputs (255, 0)", test_num);
            reset_dut();
            input1 = 8'd255;
            input2 = 8'd0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Inputs (0, 255)", test_num);
            reset_dut();
            input1 = 8'd0;
            input2 = 8'd255;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Inputs (128, 128)", test_num);
            reset_dut();
            input1 = 8'd128;
            input2 = 8'd128;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Inputs (10, 10)", test_num);
            reset_dut();
            input1 = 8'd10;
            input2 = 8'd10;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Reset during operation", test_num);

            input1 = 8'd255;
            input2 = 8'd255;
            repeat(2) @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            input1 = 8'd0;
            input2 = 8'd0;
            repeat(2) @(posedge clk);
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
        $display("simple_nn Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_output1;
        begin
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1)) begin
                $display("PASS");
                $display("  Outputs: output1=%b",
                         output1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%b",
                         expected_output1);
                $display("  Got:      output1=%b",
                         output1);
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
        $dumpvars(0,clk, input1, input2, rst, output1);
    end

endmodule
