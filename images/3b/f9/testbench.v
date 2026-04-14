`timescale 1ns/1ps

module divide_by_4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg rst;
    wire [1:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divide_by_4 dut (
        .clk(clk),
        .in_data(in_data),
        .rst(rst),
        .out_data(out_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_data = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input 0 (0 / 4 = 0)", test_num);
            reset_dut();
            in_data = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input 4 (4 / 4 = 1)", test_num);
            reset_dut();
            in_data = 8'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input 8 (8 / 4 = 2)", test_num);
            reset_dut();
            in_data = 8'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input 12 (12 / 4 = 3)", test_num);
            reset_dut();
            in_data = 8'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input 2 (Small value, floor result 0)", test_num);
            reset_dut();
            in_data = 8'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input 7 (7 / 4 = 1 remainder 3, output 1)", test_num);
            reset_dut();
            in_data = 8'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Input 15 (15 / 4 = 3 remainder 3, output 3)", test_num);
            reset_dut();
            in_data = 8'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Input 16 (16 / 4 = 4. 2-bit overflow check, 4 mod 4 = 0)", test_num);
            reset_dut();
            in_data = 8'd16;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Input 255 (Max 8-bit. 255/4 = 63. 63 mod 4 = 3)", test_num);
            reset_dut();
            in_data = 8'd255;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divide_by_4 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [1:0] expected_out_data;
        begin
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
        $dumpvars(0,clk, in_data, rst, out_data);
    end

endmodule
