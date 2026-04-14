`timescale 1ns/1ps

module dwt_hair_transform_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] signal_in;
    wire [3:0] approx_out;
    wire [3:0] detail_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_hair_transform dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .approx_out(approx_out),
        .detail_out(detail_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            signal_in = 8'h00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Identical inputs (4, 4)", test_num);
            signal_in = 8'h44;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h4, 4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Positive difference (12, 4)", test_num);
            signal_in = 8'hC4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h8, 4'h4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Negative difference (4, 12)", test_num);
            signal_in = 8'h4C;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h8, 4'hC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: High range (15, 1)", test_num);
            signal_in = 8'hF1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h8, 4'h7);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Low range (0, 14)", test_num);
            signal_in = 8'h0E;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7, 4'h9);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum inputs (15, 15)", test_num);
            signal_in = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_hair_transform Testbench");
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
        input [3:0] expected_approx_out;
        input [3:0] expected_detail_out;
        begin
            if (expected_approx_out === (expected_approx_out ^ approx_out ^ expected_approx_out) &&
                expected_detail_out === (expected_detail_out ^ detail_out ^ expected_detail_out)) begin
                $display("PASS");
                $display("  Outputs: approx_out=%h, detail_out=%h",
                         approx_out, detail_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approx_out=%h, detail_out=%h",
                         expected_approx_out, expected_detail_out);
                $display("  Got:      approx_out=%h, detail_out=%h",
                         approx_out, detail_out);
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
        $dumpvars(0,clk, rst, signal_in, approx_out, detail_out);
    end

endmodule
