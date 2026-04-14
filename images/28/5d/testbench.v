`timescale 1ns/1ps

module merge_sort_4way_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input0;
    reg [7:0] input1;
    reg [7:0] input2;
    reg [7:0] input3;
    reg rst;
    wire done;
    wire [7:0] output0;
    wire [7:0] output1;
    wire [7:0] output2;
    wire [7:0] output3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort_4way dut (
        .clk(clk),
        .input0(input0),
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .rst(rst),
        .done(done),
        .output0(output0),
        .output1(output1),
        .output2(output2),
        .output3(output3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input0 = 0;
            input1 = 0;
            input2 = 0;
            input3 = 0;
            repeat (2) @(posedge clk);
            rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Mixed Order", test_num);
            reset_dut();
            input0 = 8'd45;
            input1 = 8'd12;
            input2 = 8'd89;
            input3 = 8'd33;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd12, 8'd33, 8'd45, 8'd89);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse Sorted Order", test_num);
            reset_dut();
            input0 = 8'd200;
            input1 = 8'd150;
            input2 = 8'd100;
            input3 = 8'd50;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd50, 8'd100, 8'd150, 8'd200);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Already Sorted Order", test_num);
            reset_dut();
            input0 = 8'd10;
            input1 = 8'd20;
            input2 = 8'd30;
            input3 = 8'd40;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd10, 8'd20, 8'd30, 8'd40);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Identical Values", test_num);
            reset_dut();
            input0 = 8'd77;
            input1 = 8'd77;
            input2 = 8'd77;
            input3 = 8'd77;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd77, 8'd77, 8'd77, 8'd77);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two Pairs of Duplicates", test_num);
            reset_dut();
            input0 = 8'd10;
            input1 = 8'd5;
            input2 = 8'd10;
            input3 = 8'd5;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd5, 8'd5, 8'd10, 8'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Values (Min/Max)", test_num);
            reset_dut();
            input0 = 8'hFF;
            input1 = 8'h00;
            input2 = 8'hAA;
            input3 = 8'h01;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'h00, 8'h01, 8'hAA, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Zero and High Values", test_num);
            reset_dut();
            input0 = 8'd254;
            input1 = 8'd255;
            input2 = 8'd0;
            input3 = 8'd128;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd0, 8'd128, 8'd254, 8'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: One Bit Difference", test_num);
            reset_dut();
            input0 = 8'b10101011;
            input1 = 8'b10101010;
            input2 = 8'b10101100;
            input3 = 8'b10101001;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd169, 8'd170, 8'd171, 8'd172);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort_4way Testbench");
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
        input expected_done;
        input [7:0] expected_output0;
        input [7:0] expected_output1;
        input [7:0] expected_output2;
        input [7:0] expected_output3;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output0 === (expected_output0 ^ output0 ^ expected_output0) &&
                expected_output1 === (expected_output1 ^ output1 ^ expected_output1) &&
                expected_output2 === (expected_output2 ^ output2 ^ expected_output2) &&
                expected_output3 === (expected_output3 ^ output3 ^ expected_output3)) begin
                $display("PASS");
                $display("  Outputs: done=%b, output0=%h, output1=%h, output2=%h, output3=%h",
                         done, output0, output1, output2, output3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, output0=%h, output1=%h, output2=%h, output3=%h",
                         expected_done, expected_output0, expected_output1, expected_output2, expected_output3);
                $display("  Got:      done=%b, output0=%h, output1=%h, output2=%h, output3=%h",
                         done, output0, output1, output2, output3);
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
        $dumpvars(0,clk, input0, input1, input2, input3, rst, done, output0, output1, output2, output3);
    end

endmodule
