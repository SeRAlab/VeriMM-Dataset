`timescale 1ns/1ps

module restoring_divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dividend;
    reg [7:0] divisor;
    reg rst;
    wire done;
    wire [15:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    restoring_divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .rst(rst),
        .done(done),
        .quotient(quotient),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1000 / 25", test_num);
            dividend = 16'd1000;
            divisor  = 8'd25;
            reset_dut();
            wait(done);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 16'd40, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 500 / 7", test_num);
            dividend = 16'd500;
            divisor  = 8'd7;
            reset_dut();
            wait(done);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 16'd71, 8'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 5 / 20", test_num);
            dividend = 16'd5;
            divisor  = 8'd20;
            reset_dut();
            wait(done);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 16'd0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1234 / 1", test_num);
            dividend = 16'd1234;
            divisor  = 8'd1;
            reset_dut();
            wait(done);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 16'd1234, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 50000 / 123", test_num);
            dividend = 16'd50000;
            divisor  = 8'd123;
            reset_dut();
            wait(done);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 16'd406, 8'd62);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 65535 / 255", test_num);
            dividend = 16'hFFFF;
            divisor  = 8'hFF;
            reset_dut();
            wait(done);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 16'd257, 8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 / 50", test_num);
            dividend = 16'd0;
            divisor  = 8'd50;
            reset_dut();
            wait(done);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 16'd0, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("restoring_divider Testbench");
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
        input expected_done;
        input [15:0] expected_quotient;
        input [7:0] expected_remainder;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h, remainder=%h",
                         expected_done, expected_quotient, expected_remainder);
                $display("  Got:      done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
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
        $dumpvars(0,clk, dividend, divisor, rst, done, quotient, remainder);
    end

endmodule
