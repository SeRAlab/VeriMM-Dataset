`timescale 1ns/1ps

module johnson_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter dut (
        .clk(clk),
        .reset(reset),
        .count(count)
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
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Reset Check", test_num);
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clk);
            test_num = test_num + 1;
            $display("Test %0d: First Shift (10000)", test_num);
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(5) @(negedge clk);
            test_num = test_num + 1;
            $display("Test %0d: Half Cycle Fill (11111)", test_num);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat(6) @(negedge clk);
            test_num = test_num + 1;
            $display("Test %0d: Start of Inversion (01111)", test_num);
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            repeat(10) @(negedge clk);
            test_num = test_num + 1;
            $display("Test %0d: Full Cycle Reset (00000)", test_num);
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            repeat(13) @(negedge clk);
            test_num = test_num + 1;
            $display("Test %0d: Wrap Around Sequence (11100)", test_num);
            #1;

            check_outputs(5'b11100);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            repeat(9) @(negedge clk);
            test_num = test_num + 1;
            $display("Test %0d: State before final reset (00001)", test_num);
            #1;

            check_outputs(5'b00001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter Testbench");
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
        input [4:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, reset, count);
    end

endmodule
