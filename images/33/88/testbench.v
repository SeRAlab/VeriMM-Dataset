`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
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
            $display("testcase001: Impulse Response");
            reset_dut();
            x = 16'sd10; @(posedge clk); #1;
            x = 16'sd0;  @(posedge clk); #1;
            x = 16'sd0;  @(posedge clk); #1;
            #1;

            check_outputs(16'sd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("testcase002: Step Response");
            reset_dut();
            x = 16'sd10; @(posedge clk); #1;
            x = 16'sd10; @(posedge clk); #1;
            x = 16'sd10; @(posedge clk); #1;
            #1;

            check_outputs(16'sd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("testcase003: Negative Input Response");
            reset_dut();
            x = -16'sd5; @(posedge clk); #1;
            x = -16'sd5; @(posedge clk); #1;
            x = -16'sd5; @(posedge clk); #1;
            #1;

            check_outputs(-16'sd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("testcase004: Alternating Signal");
            reset_dut();
            x = 16'sd10;  @(posedge clk); #1;
            x = -16'sd10; @(posedge clk); #1;
            x = 16'sd10;  @(posedge clk); #1;
            #1;

            check_outputs(16'sd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("testcase005: Zero Input Stability");
            reset_dut();
            x = 16'sd100; @(posedge clk); #1;
            x = 16'sd0;   @(posedge clk); #1;
            x = 16'sd0;   @(posedge clk); #1;
            x = 16'sd0;   @(posedge clk); #1;




            #1;





            check_outputs(-16'sd200);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("iir_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_y;
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
