`timescale 1ns/1ps

module IIR_Filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x_n;
    reg [15:0] x_n1;
    wire [15:0] y_n;
    wire [15:0] y_n1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IIR_Filter dut (
        .clk(clk),
        .rst(rst),
        .x_n(x_n),
        .x_n1(x_n1),
        .y_n(y_n),
        .y_n1(y_n1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_n = 16'd0;
            x_n1 = 16'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset and Zero Input", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Impulse Response (x_n=0x000A)", test_num);
            reset_dut();
            x_n = 16'h000A;
            x_n1 = 16'h0000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h000A, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple Samples (Feedback Check)", test_num);
            reset_dut();


            x_n = 16'h0005;
            x_n1 = 16'h0000;
            @(posedge clk);


            #1;
            x_n = 16'h0002;
            x_n1 = 16'h0005;
            @(posedge clk);
            #1;




            #1;





            check_outputs(16'h000C, 16'h0005);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Large Value Input", test_num);
            reset_dut();
            x_n = 16'h1000;
            x_n1 = 16'h1000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2000, 16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("IIR_Filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_y_n;
        input [15:0] expected_y_n1;
        begin
            if (expected_y_n === (expected_y_n ^ y_n ^ expected_y_n) &&
                expected_y_n1 === (expected_y_n1 ^ y_n1 ^ expected_y_n1)) begin
                $display("PASS");
                $display("  Outputs: y_n=%h, y_n1=%h",
                         y_n, y_n1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_n=%h, y_n1=%h",
                         expected_y_n, expected_y_n1);
                $display("  Got:      y_n=%h, y_n1=%h",
                         y_n, y_n1);
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
        $dumpvars(0,clk, rst, x_n, x_n1, y_n, y_n1);
    end

endmodule
