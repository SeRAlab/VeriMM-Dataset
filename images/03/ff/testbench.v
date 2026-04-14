`timescale 1ns/1ps

module point_doubling_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] x;
    reg [7:0] y;
    wire done;
    wire [7:0] x_out;
    wire [7:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    point_doubling_fsm dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .done(done),
        .x_out(x_out),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 8'd0;
            y = 8'd0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic values (3, 5)", test_num);
            reset_dut();
            x = 8'd3;
            y = 8'd5;
            wait(done == 1'b1);
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 8'd9, 8'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range values (15, 10)", test_num);
            reset_dut();
            x = 8'd15;
            y = 8'd10;
            wait(done == 1'b1);
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 8'd225, 8'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Modulo reduction (17, 20)", test_num);
            reset_dut();
            x = 8'd17;
            y = 8'd20;
            wait(done == 1'b1);
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 8'd32, 8'd143);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High-range values (255, 254)", test_num);
            reset_dut();
            x = 8'd255;
            y = 8'd254;
            wait(done == 1'b1);
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 8'd4, 8'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero and One (0, 1)", test_num);
            reset_dut();
            x = 8'd0;
            y = 8'd1;
            wait(done == 1'b1);
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 8'd0, 8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex reduction (128, 64)", test_num);
            reset_dut();
            x = 8'd128;
            y = 8'd64;
            wait(done == 1'b1);
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 8'd193, 8'd241);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("point_doubling_fsm Testbench");
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
        input expected_done;
        input [7:0] expected_x_out;
        input [7:0] expected_y_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, x_out=%h, y_out=%h",
                         done, x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, x_out=%h, y_out=%h",
                         expected_done, expected_x_out, expected_y_out);
                $display("  Got:      done=%b, x_out=%h, y_out=%h",
                         done, x_out, y_out);
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
        $dumpvars(0,clk, reset, x, y, done, x_out, y_out);
    end

endmodule
