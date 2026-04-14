`timescale 1ns/1ps

module divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] numerator;
    reg reset;
    wire [7:0] quotient;
    wire [1:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider dut (
        .clk(clk),
        .numerator(numerator),
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
            numerator = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Numerator = 0", test_num);
            reset_dut();
            numerator = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Numerator = 3 (Exact division)", test_num);
            reset_dut();
            numerator = 8'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1, 2'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Numerator = 4 (Remainder 1)", test_num);
            reset_dut();
            numerator = 8'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1, 2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Numerator = 5 (Remainder 2)", test_num);
            reset_dut();
            numerator = 8'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1, 2'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Numerator = 30", test_num);
            reset_dut();
            numerator = 8'd30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10, 2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Numerator = 255 (Max Value, Exact)", test_num);
            reset_dut();
            numerator = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd85, 2'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Numerator = 254", test_num);
            reset_dut();
            numerator = 8'd254;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd84, 2'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Numerator = 253", test_num);
            reset_dut();
            numerator = 8'd253;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd84, 2'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Numerator = 64", test_num);
            reset_dut();
            numerator = 8'd64;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd21, 2'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Numerator = 2 (Less than divisor)", test_num);
            reset_dut();
            numerator = 8'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 2'd2);
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
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_remainder;
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
        $dumpvars(0,clk, numerator, reset, quotient, remainder);
    end

endmodule
