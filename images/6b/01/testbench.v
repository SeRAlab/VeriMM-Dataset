`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire carry_out;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .clk(clk),
        .reset(reset),
        .carry_out(carry_out),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Synchronous Reset", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Single Increment", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Multiple Increments (to 8)", test_num);
            reset_dut();
            repeat(8) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Terminal Count and Carry Out", test_num);
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Counter Wrap-Around", test_num);
            reset_dut();
            repeat(16) @(posedge clk);
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Mid-Count Synchronous Reset", test_num);
            reset_dut();
            repeat(5) @(posedge clk);


            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Carry Out Transition (15 to 0)", test_num);
            reset_dut();
            repeat(14) @(posedge clk);
            @(posedge clk);
            if (carry_out !== 1'b1) $display("Error: Carry out should be 1 at count 15");
            @(posedge clk);
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
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
        input expected_carry_out;
        input [3:0] expected_count;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, count=%h",
                         carry_out, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, count=%h",
                         expected_carry_out, expected_count);
                $display("  Got:      carry_out=%b, count=%h",
                         carry_out, count);
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
        $dumpvars(0,clk, reset, carry_out, count);
    end

endmodule
