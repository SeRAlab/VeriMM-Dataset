`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] x_in;
    wire [7:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_in = 0;
            @(posedge clk);
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            x_in = 4'd0; @(posedge clk);
            x_in = 4'd0; @(posedge clk);
            x_in = 4'd0; @(posedge clk);
            x_in = 4'd0; @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            x_in = 4'd1; @(posedge clk);
            x_in = 4'd0; @(posedge clk);
            x_in = 4'd0; @(posedge clk);
            x_in = 4'd0; @(posedge clk);
            #1 #1;
 check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            x_in = 4'd1; @(posedge clk);
            x_in = 4'd1; @(posedge clk);
            x_in = 4'd1; @(posedge clk);
            x_in = 4'd1; @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            x_in = 4'd1; @(posedge clk);
            x_in = 4'd2; @(posedge clk);
            x_in = 4'd3; @(posedge clk);
            x_in = 4'd4; @(posedge clk);
            #1 #1;
 check_outputs(8'd20);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            x_in = 4'd15; @(posedge clk);
            x_in = 4'd15; @(posedge clk);
            x_in = 4'd15; @(posedge clk);
            x_in = 4'd15; @(posedge clk);
            #1 #1;
 check_outputs(8'd150);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            x_in = 4'd5; @(posedge clk);
            x_in = 4'd2; @(posedge clk);
            x_in = 4'd1; @(posedge clk);
            x_in = 4'd8; @(posedge clk);
            #1 #1;
 check_outputs(8'd36);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            x_in = 4'd10; @(posedge clk);
            x_in = 4'd0;  @(posedge clk);
            x_in = 4'd0;  @(posedge clk);
            x_in = 4'd0;  @(posedge clk);
            #1 #1;
 check_outputs(8'd40);
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
        input [7:0] expected_y_out;
        begin
            if (expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: y_out=%h",
                         y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_out=%h",
                         expected_y_out);
                $display("  Got:      y_out=%h",
                         y_out);
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
        $dumpvars(0,clk, rst, x_in, y_out);
    end

endmodule
