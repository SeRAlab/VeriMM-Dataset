`timescale 1ns/1ps

module divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg reset;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider dut (
        .clk(clk),
        .dividend(dividend),
        .divisor(divisor),
        .reset(reset),
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
            reset = 1;
            dividend = 0;
            divisor = 0;
            @(posedge clk);
            #1 reset = 0;

            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            dividend = 8'd20;
            divisor  = 8'd5;
            repeat(15) @(posedge clk);
            test_num = test_num + 1;
            $write("Testcase %0d (20/5): ", test_num);
            #1;

            check_outputs(8'd4, 8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            dividend = 8'd17;
            divisor  = 8'd3;
            repeat(15) @(posedge clk);
            test_num = test_num + 1;
            $write("Testcase %0d (17/3): ", test_num);
            #1;

            check_outputs(8'd5, 8'd2);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            dividend = 8'd50;
            divisor  = 8'd0;
            repeat(15) @(posedge clk);
            test_num = test_num + 1;
            $write("Testcase %0d (50/0): ", test_num);
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            dividend = 8'd5;
            divisor  = 8'd10;
            repeat(15) @(posedge clk);
            test_num = test_num + 1;
            $write("Testcase %0d (5/10): ", test_num);
            #1;

            check_outputs(8'd0, 8'd5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            dividend = 8'hFF;
            divisor  = 8'd1;
            repeat(15) @(posedge clk);
            test_num = test_num + 1;
            $write("Testcase %0d (255/1): ", test_num);
            #1;

            check_outputs(8'd255, 8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            dividend = 8'hFF;
            divisor  = 8'd2;
            repeat(15) @(posedge clk);
            test_num = test_num + 1;
            $write("Testcase %0d (255/2): ", test_num);
            #1;

            check_outputs(8'd127, 8'd1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            dividend = 8'd0;
            divisor  = 8'd10;
            repeat(15) @(posedge clk);
            test_num = test_num + 1;
            $write("Testcase %0d (0/10): ", test_num);
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            dividend = 8'd123;
            divisor  = 8'd123;
            repeat(15) @(posedge clk);
            test_num = test_num + 1;
            $write("Testcase %0d (123/123): ", test_num);
            #1;

            check_outputs(8'd1, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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
        $dumpvars(0,clk, dividend, divisor, reset, quotient, remainder);
    end

endmodule
