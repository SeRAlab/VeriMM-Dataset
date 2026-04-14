`timescale 1ns/1ps

module pipeline_2stage_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in_data;
    reg rst;
    wire [4:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_2stage dut (
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
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 0", test_num);
            reset_dut();
            in_data = 4'd0;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 2", test_num);
            reset_dut();
            in_data = 4'd2;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 7", test_num);
            reset_dut();
            in_data = 4'd7;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 14", test_num);
            reset_dut();
            in_data = 4'd14;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 15 (Overflow Case)", test_num);
            reset_dut();
            in_data = 4'd15;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 4", test_num);
            reset_dut();
            in_data = 4'd4;
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_2stage Testbench");
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
        input [4:0] expected_out_data;
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
