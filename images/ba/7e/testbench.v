`timescale 1ns/1ps

module binary_counter_with_carry_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire carry_out;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter_with_carry dut (
        .clk(clk),
        .reset(reset),
        .carry_out(carry_out),
        .q(q)
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
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Increment (0 to 1)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Increments (0 to 8)", test_num);
            reset_dut();
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow/Carry Check at Max Value (q=15)", test_num);
            reset_dut();
            repeat(15) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap-around Check (15 to 0)", test_num);
            reset_dut();
            repeat(16) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset during high count", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            reset_dut();
            #1;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter_with_carry Testbench");
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
        input [3:0] expected_q;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, q=%h",
                         carry_out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, q=%h",
                         expected_carry_out, expected_q);
                $display("  Got:      carry_out=%b, q=%h",
                         carry_out, q);
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
        $dumpvars(0,clk, reset, carry_out, q);
    end

endmodule
