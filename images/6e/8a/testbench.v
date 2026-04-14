`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] a;
    reg [13:0] b;
    reg clk;
    reg reset;
    wire [13:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            #15;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 14'h0005;
            b = 14'h000A;
            @(posedge clk);
            #1;
            $display("Test %0d: Basic Addition (5 + 10)", test_num);
            #1;

            check_outputs(14'h000F);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 14'h0000;
            b = 14'h0000;
            @(posedge clk);
            #1;
            $display("Test %0d: Adding Zeros", test_num);
            #1;

            check_outputs(14'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 14'h3FFF;
            b = 14'h0001;
            @(posedge clk);
            #1;
            $display("Test %0d: Max Value Wrap-around (0x3FFF + 1)", test_num);
            #1;

            check_outputs(14'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 14'h1234;
            b = 14'h0ABC;
            @(posedge clk);
            #1;
            $display("Test %0d: Medium Values (0x1234 + 0x0ABC)", test_num);
            #1;

            check_outputs(14'h1CF0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 14'h3FFF;
            b = 14'h3FFF;

            @(negedge clk);
            reset = 1;
            #5;
            $display("Test %0d: Asynchronous Reset Verification", test_num);
            #1;

            check_outputs(14'h0000);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 14'h2AAA;
            b = 14'h1555;
            @(posedge clk);
            #1;
            $display("Test %0d: Alternating Bits (0x2AAA + 0x1555)", test_num);
            #1;

            check_outputs(14'h3FFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ripple_carry_adder Testbench");
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
        input [13:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,a, b, clk, reset, sum);
    end

endmodule
