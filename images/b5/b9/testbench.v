`timescale 1ns/1ps

module gray_code_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [3:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_code_counter dut (
        .clk(clk),
        .reset(reset),
        .gray(gray)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Reset Check", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #1;
            $display("Testcase %0d: 1 Clock Cycle (Binary 1 -> Gray 1)", test_num);
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase %0d: 3 Clock Cycles (Binary 3 -> Gray 2)", test_num);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(7) @(posedge clk);
            #1;
            $display("Testcase %0d: 7 Clock Cycles (Binary 7 -> Gray 4)", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            $display("Testcase %0d: 10 Clock Cycles (Binary 10 -> Gray 15)", test_num);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(15) @(posedge clk);
            #1;
            $display("Testcase %0d: 15 Clock Cycles (Binary 15 -> Gray 8)", test_num);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            $display("Testcase %0d: Wrap-around Check (16 cycles)", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            repeat(20) @(posedge clk);
            #1;
            $display("Testcase %0d: Wrap-around Check (20 cycles -> Binary 4 -> Gray 6)", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_code_counter Testbench");
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
        input [3:0] expected_gray;
        begin
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
        $dumpvars(0,clk, reset, gray);
    end

endmodule
