`timescale 1ns/1ps

module rrt_acceptor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] last_x;
    reg [7:0] last_y;
    reg [7:0] random_x;
    reg [7:0] random_y;
    reg reset;
    reg [7:0] threshold;
    wire accept_signal;
    wire [7:0] accepted_x;
    wire [7:0] accepted_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_acceptor dut (
        .clk(clk),
        .last_x(last_x),
        .last_y(last_y),
        .random_x(random_x),
        .random_y(random_y),
        .reset(reset),
        .threshold(threshold),
        .accept_signal(accept_signal),
        .accepted_x(accepted_x),
        .accepted_y(accepted_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            last_x = 0;
            last_y = 0;
            random_x = 0;
            random_y = 0;
            threshold = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            last_x = 8'd50;
            last_y = 8'd50;
            random_x = 8'd50;
            random_y = 8'd50;
            threshold = 8'd10;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Same Point", test_num);
            #1;

            check_outputs(1'b1, 8'd50, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            last_x = 8'd10;
            last_y = 8'd10;
            random_x = 8'd20;
            random_y = 8'd20;
            threshold = 8'd50;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Far Point (Reject)", test_num);
            #1;

            check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            last_x = 8'd100;
            last_y = 8'd100;
            random_x = 8'd103;
            random_y = 8'd104;
            threshold = 8'd30;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Within Threshold (Accept)", test_num);
            #1;

            check_outputs(1'b1, 8'd103, 8'd104);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            last_x = 8'd0;
            last_y = 8'd0;
            random_x = 8'd0;
            random_y = 8'd5;
            threshold = 8'd25;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Boundary Equality (Reject)", test_num);
            #1;

            check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            last_x = 8'd10;
            last_y = 8'd10;
            random_x = 8'd11;
            random_y = 8'd11;
            threshold = 8'd100;

            reset = 1;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Reset Signal Dominance", test_num);
            #1;

            check_outputs(1'b0, 8'd0, 8'd0);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            last_x = 8'd0;
            last_y = 8'd0;
            random_x = 8'd255;
            random_y = 8'd255;
            threshold = 8'd255;

            @(posedge clk);
            #2;
            $display("Testcase %0d: Maximum Distance Range (Reject)", test_num);
            #1;

            check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_acceptor Testbench");
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
        input expected_accept_signal;
        input [7:0] expected_accepted_x;
        input [7:0] expected_accepted_y;
        begin
            if (expected_accept_signal === (expected_accept_signal ^ accept_signal ^ expected_accept_signal) &&
                expected_accepted_x === (expected_accepted_x ^ accepted_x ^ expected_accepted_x) &&
                expected_accepted_y === (expected_accepted_y ^ accepted_y ^ expected_accepted_y)) begin
                $display("PASS");
                $display("  Outputs: accept_signal=%b, accepted_x=%h, accepted_y=%h",
                         accept_signal, accepted_x, accepted_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accept_signal=%b, accepted_x=%h, accepted_y=%h",
                         expected_accept_signal, expected_accepted_x, expected_accepted_y);
                $display("  Got:      accept_signal=%b, accepted_x=%h, accepted_y=%h",
                         accept_signal, accepted_x, accepted_y);
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
        $dumpvars(0,clk, last_x, last_y, random_x, random_y, reset, threshold, accept_signal, accepted_x, accepted_y);
    end

endmodule
