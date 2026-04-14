`timescale 1ns/1ps

module binary_adder_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg carry_in;
    reg clk;
    wire carry_out;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_adder dut (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .clk(clk),
        .carry_out(carry_out),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 4'b0000;
            b = 4'b0000;
            carry_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic addition 1 + 2", test_num);
            reset_dut();
            a = 4'b0001;
            b = 4'b0010;
            carry_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with carry-in 6 + 3 + 1", test_num);
            reset_dut();
            a = 4'b0110;
            b = 4'b0011;
            carry_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry-out detection 15 + 1", test_num);
            reset_dut();
            a = 4'b1111;
            b = 4'b0001;
            carry_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max values 15 + 15 + 1", test_num);
            reset_dut();
            a = 4'b1111;
            b = 4'b1111;
            carry_in = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero addition", test_num);
            reset_dut();
            a = 4'b0000;
            b = 4'b0000;
            carry_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of 2 carry 8 + 8", test_num);
            reset_dut();
            a = 4'b1000;
            b = 4'b1000;
            carry_in = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_adder Testbench");
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
        input expected_carry_out;
        input [3:0] expected_sum;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum=%h",
                         carry_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum=%h",
                         expected_carry_out, expected_sum);
                $display("  Got:      carry_out=%b, sum=%h",
                         carry_out, sum);
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
        $dumpvars(0,a, b, carry_in, clk, carry_out, sum);
    end

endmodule
