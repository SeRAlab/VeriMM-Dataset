`timescale 1ns/1ps

module cordic_vectoring_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg [3:0] x_in;
    reg [3:0] y_in;
    wire done;
    wire [3:0] theta_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cordic_vectoring dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .x_in(x_in),
        .y_in(y_in),
        .done(done),
        .theta_out(theta_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            x_in = 4'b0000;
            y_in = 4'b0000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            x_in = 4'h7;
            y_in = 4'h0;
            enable = 1;
            @(posedge clk);
            enable = 0;
            wait(done);
            @(posedge clk);
            $display("Test Case 001: (0.875, 0)");
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            x_in = 4'h4;
            y_in = 4'h4;
            enable = 1;
            @(posedge clk);
            enable = 0;
            wait(done);
            @(posedge clk);
            $display("Test Case 002: (0.5, 0.5)");
            #1;

            check_outputs(1'b1, 4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            x_in = 4'h0;
            y_in = 4'h4;
            enable = 1;
            @(posedge clk);
            enable = 0;
            wait(done);
            @(posedge clk);
            $display("Test Case 003: (0, 0.5)");
            #1;

            check_outputs(1'b1, 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            x_in = 4'h4;
            y_in = 4'hC;
            enable = 1;
            @(posedge clk);
            enable = 0;
            wait(done);
            @(posedge clk);
            $display("Test Case 004: (0.5, -0.5)");
            #1;

            check_outputs(1'b1, 4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            x_in = 4'h0;
            y_in = 4'hC;
            enable = 1;
            @(posedge clk);
            enable = 0;
            wait(done);
            @(posedge clk);
            $display("Test Case 005: (0, -0.5)");
            #1;

            check_outputs(1'b1, 4'hD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cordic_vectoring Testbench");
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
        input expected_done;
        input [3:0] expected_theta_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_theta_out === (expected_theta_out ^ theta_out ^ expected_theta_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, theta_out=%h",
                         done, theta_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, theta_out=%h",
                         expected_done, expected_theta_out);
                $display("  Got:      done=%b, theta_out=%h",
                         done, theta_out);
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
        $dumpvars(0,clk, enable, reset, x_in, y_in, done, theta_out);
    end

endmodule
