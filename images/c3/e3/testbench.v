`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg X;
    reg carry_in;
    wire carry_out;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .A(A),
        .B(B),
        .X(X),
        .carry_in(carry_in),
        .carry_out(carry_out),
        .sum(sum)
    );

        task reset_dut;

        begin
            A <= 8'd0;
            B <= 8'd0;
            X <= 1'b0;
            carry_in <= 1'b0;
            rst_n <= 1'b0;
            repeat(2) @(posedge clk);
            rst_n <= 1'b1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A <= 8'd15; B <= 8'd25; X <= 1'b0; carry_in <= 1'b0;
            repeat(LATENCY) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A <= 8'd200; B <= 8'd100; X <= 1'b0; carry_in <= 1'b0;
            repeat(LATENCY) @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd44);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A <= 8'd127; B <= 8'd127; X <= 1'b0; carry_in <= 1'b1;
            repeat(LATENCY) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A <= 8'd50; B <= 8'd20; X <= 1'b1; carry_in <= 1'b1;
            repeat(LATENCY) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A <= 8'd20; B <= 8'd50; X <= 1'b1; carry_in <= 1'b1;
            repeat(LATENCY) @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd226);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A <= 8'd100; B <= 8'd40; X <= 1'b1; carry_in <= 1'b0;
            repeat(LATENCY) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'd59);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A <= 8'd10; B <= 8'd10; X <= 1'b1; carry_in <= 1'b0;
            repeat(LATENCY) @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd255);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            A <= 8'hFF; B <= 8'hFF; X <= 1'b0; carry_in <= 1'b1;
            repeat(LATENCY) @(posedge clk);
            #1;

            check_outputs(1'b1, 8'hFF);
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
        input expected_carry_out;
        input [7:0] expected_sum;
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
        $dumpvars(0,A, B, X, carry_in, carry_out, sum);
    end

endmodule
