`timescale 1ns/1ps

module divider_4bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] denominator;
    reg [3:0] numerator;
    wire [3:0] quotient;
    wire [3:0] remainder;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_4bit dut (
        .clk(clk),
        .denominator(denominator),
        .numerator(numerator),
        .quotient(quotient),
        .remainder(remainder),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            numerator = 0;
            denominator = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 12 / 3", test_num);
            reset_dut();
            numerator = 4'd12;
            denominator = 4'd3;
            @(posedge clk);
            wait(valid === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4, 4'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 15 / 4", test_num);
            reset_dut();
            numerator = 4'd15;
            denominator = 4'd4;
            @(posedge clk);
            wait(valid === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 4'd3, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 3 / 7", test_num);
            reset_dut();
            numerator = 4'd3;
            denominator = 4'd7;
            @(posedge clk);
            wait(valid === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd3, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 9 / 1", test_num);
            reset_dut();
            numerator = 4'd9;
            denominator = 4'd1;
            @(posedge clk);
            wait(valid === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9, 4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 10 / 10", test_num);
            reset_dut();
            numerator = 4'd10;
            denominator = 4'd10;
            @(posedge clk);
            wait(valid === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 4'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 / 5", test_num);
            reset_dut();
            numerator = 4'd0;
            denominator = 4'd5;
            @(posedge clk);
            wait(valid === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 15 / 2", test_num);
            reset_dut();
            numerator = 4'd15;
            denominator = 4'd2;
            @(posedge clk);
            wait(valid === 1'b1);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7, 4'd1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_4bit Testbench");
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
        input [3:0] expected_quotient;
        input [3:0] expected_remainder;
        input expected_valid;
        begin
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h, valid=%b",
                         expected_quotient, expected_remainder, expected_valid);
                $display("  Got:      quotient=%h, remainder=%h, valid=%b",
                         quotient, remainder, valid);
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
        $dumpvars(0,clk, denominator, numerator, quotient, remainder, valid);
    end

endmodule
