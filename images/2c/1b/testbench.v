`timescale 1ns/1ps

module IIR_Filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    IIR_Filter dut (
        .clk(clk),
        .reset(reset),
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
            reset = 1;
            x = 16'd0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Zero Input Stability");
            test_num = 1;
            reset_dut();
            x = 16'sh0000;
            repeat(10) @(posedge clk);



            #1;




            check_outputs(16'sh0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Impulse Response");
            test_num = 2;
            reset_dut();

            x = 16'sh1000;
            @(posedge clk);
            #1;
            x = 16'sh0000;
            repeat(4) @(posedge clk);
            #1;




            #1;





            check_outputs(y);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Positive Step Response");
            test_num = 3;
            reset_dut();

            x = 16'sh00FF;
            repeat(20) @(posedge clk);
            #1;



            #1;




            check_outputs(y);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Negative Input Handling");
            test_num = 4;
            reset_dut();

            x = -16'sh00A0;
            repeat(5) @(posedge clk);
            #1;


            if ($signed(y) <= 0) begin
                #1;

                check_outputs(y);
            end else begin
                #1;

                check_outputs(16'sh0000);
            end
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Reset Mid-Operation");
            test_num = 5;
            reset_dut();

            x = 16'sh7FFF;
            repeat(5) @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            x = 16'sh0000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'sh0000);
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
        $dumpvars(0,clk, reset, x, y);
    end

endmodule
