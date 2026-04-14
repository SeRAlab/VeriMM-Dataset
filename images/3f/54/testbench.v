`timescale 1ns/1ps

module chebyshev_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] x;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chebyshev_filter dut (
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
            x = 4'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            $display("DUT Reset at time %0t", $time);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Input Stability", test_num);
            reset_dut();

            x = 4'd0;


            repeat(10) @(posedge clk);


            #1;



            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Impulse Response", test_num);
            reset_dut();

            x = 4'hF;
            @(posedge clk);
            x = 4'h0;


            repeat(10) @(posedge clk);




            if (y != 4'h0) begin
                $display("Impulse responded with non-zero value: %h", y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter remained at 0 despite impulse");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Step Response (Steady State)", test_num);
            reset_dut();

            x = 4'h8;


            repeat(20) @(posedge clk);



            if (y >= 4'h4 && y <= 4'hC) begin
                $display("Step Response within expected range: %h", y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Step response out of range: %h", y);
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Input Saturation", test_num);
            reset_dut();

            x = 4'hF;
            repeat(15) @(posedge clk);



            if (y > 4'h0) begin
                $display("Filter handled max input. Output: %h", y);
                pass_count = pass_count + 1;
            } else {
                $display("FAIL: Filter output wrapped to 0 or failed to propagate.");
                fail_count = fail_count + 1;
            }
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition Test", test_num);
            reset_dut();

            x = 4'hA;
            repeat(10) @(posedge clk);
            x = 4'h2;
            repeat(10) @(posedge clk);


            if (y < 4'hA) begin
                $display("Filter followed input transition down. Output: %h", y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Filter output did not decrease.");
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
        $display("chebyshev_filter Testbench");
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
        input [3:0] expected_y;
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
