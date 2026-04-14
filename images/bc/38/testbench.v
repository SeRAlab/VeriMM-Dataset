`timescale 1ns/1ps

module gray_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [4:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_counter dut (
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
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: After 1 clock cycle", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: After 4 clock cycles", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: After 10 clock cycles", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: After 16 clock cycles", test_num);
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h18);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: After 31 clock cycles", test_num);
            reset_dut();
            repeat(31) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: After 32 clock cycles (Rollover)", test_num);
            reset_dut();
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: After 50 clock cycles", test_num);
            reset_dut();
            repeat(50) @(posedge clk);
            #1;

            #1;


            check_outputs(5'h1B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_counter Testbench");
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
        input [4:0] expected_gray;
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
