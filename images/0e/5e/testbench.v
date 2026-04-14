`timescale 1ns/1ps

module butterworth_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] x_in;
    wire [7:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    butterworth_filter dut (
        .clk(clk),
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
            x_in = 8'h0;

            repeat (20) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Input Response", test_num);
            reset_dut();

            x_in = 8'd0;
            repeat (20) @(posedge clk);


            #1;



            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: DC Steady State (128)", test_num);
            reset_dut();

            x_in = 8'd128;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(8'd128);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: DC Steady State (255)", test_num);
            reset_dut();

            x_in = 8'd255;
            repeat (100) @(posedge clk);


            #1;



            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: High Frequency Attenuation", test_num);
            reset_dut();


            repeat (50) begin
                x_in = 8'd255;
                @(posedge clk);
                x_in = 8'd0;
                @(posedge clk);
            end



            #1;




            check_outputs(8'd127);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Step Response Transient", test_num);
            reset_dut();

            x_in = 8'd200;

            repeat (2) @(posedge clk);


            if (y_out > 8'd0 && y_out < 8'd200) begin
                $display("PASS: Filter is transitioning (y_out=%d)", y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter step response incorrect (y_out=%d)", y_out);
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("butterworth_filter Testbench");
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
        $dumpvars(0,clk, x_in, y_out);
    end

endmodule
