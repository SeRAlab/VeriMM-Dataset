`timescale 1ns/1ps

module binary_up_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg en;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_up_counter dut (
        .clk(clk),
        .clr(clr),
        .en(en),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            en = 0;
            #15;
            clr = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Normal Incrementing (5 cycles)", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Enable Signal (Pause at 3)", test_num);
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Counter Rollover", test_num);
            reset_dut();
            en = 1;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Maximum Value (15)", test_num);
            reset_dut();
            en = 1;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Async Clear Priority mid-cycle", test_num);
            reset_dut();
            en = 1;
            repeat(7) @(posedge clk);
            @(negedge clk);
            clr = 1;
            #2;
            #1;

            check_outputs(4'd0);
            clr = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Intermittent Enable", test_num);
            reset_dut();
            en = 1; @(posedge clk);
            en = 0; @(posedge clk);
            en = 1; @(posedge clk);
            en = 0; @(posedge clk);
            en = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_up_counter Testbench");
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
        input [3:0] expected_count;
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
        $dumpvars(0,clk, clr, en, count);
    end

endmodule
