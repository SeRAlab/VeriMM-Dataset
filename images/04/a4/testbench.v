`timescale 1ns/1ps

module LFSR_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [2:0] taps;
    wire [7:0] random_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LFSR dut (
        .clk(clk),
        .rst(rst),
        .taps(taps),
        .random_out(random_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            taps = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Step with Tap 0", test_num);
            reset_dut();
            taps = 3'b000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 4 Cycles with Tap 0", test_num);
            reset_dut();
            taps = 3'b000;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 3 Cycles with Tap 2", test_num);
            reset_dut();
            taps = 3'b010;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h09);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 3 Cycles with Tap 7 (Zero Feedback)", test_num);
            reset_dut();
            taps = 3'b111;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Change Tap Mid-Sequence", test_num);
            reset_dut();
            taps = 3'b000;
            @(posedge clk);
            taps = 3'b011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 8 Cycles with Tap 1", test_num);
            reset_dut();
            taps = 3'b001;
            repeat(8) @(posedge clk);
            #1;


            #1;



            check_outputs(8'h11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LFSR Testbench");
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
        input [7:0] expected_random_out;
        begin
            if (expected_random_out === (expected_random_out ^ random_out ^ expected_random_out)) begin
                $display("PASS");
                $display("  Outputs: random_out=%h",
                         random_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: random_out=%h",
                         expected_random_out);
                $display("  Got:      random_out=%h",
                         random_out);
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
        $dumpvars(0,clk, rst, taps, random_out);
    end

endmodule
