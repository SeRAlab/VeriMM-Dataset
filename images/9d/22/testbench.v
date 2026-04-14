`timescale 1ns/1ps

module down_counter_7bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset_n;
    wire [6:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter_7bit dut (
        .clk(clk),
        .en(en),
        .reset_n(reset_n),
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
            reset_n = 0;
            en = 0;
            @(negedge clk);
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();

            #1;


            check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Decrement (Wrap-around 0 to 127)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            @(negedge clk);
            en = 0;

            #1;


            check_outputs(7'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple Decrements", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(10) @(negedge clk);
            en = 0;

            #1;


            check_outputs(7'h76);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable Signal Hold", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(5) @(negedge clk);
            en = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(7'h7B);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Synchronous Reset Priority", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(5) @(negedge clk);
            reset_n = 0;
            @(negedge clk);
            reset_n = 1;
            en = 0;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Interleaved Enable", test_num);
            reset_dut();
            @(negedge clk);
            en = 1; @(negedge clk);
            en = 0; @(negedge clk);
            en = 1; @(negedge clk);
            en = 0; @(negedge clk);
            en = 1; @(negedge clk);
            en = 0;
            #1;

            check_outputs(7'h7D);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Full Cycle Wrap-around", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat(128) @(negedge clk);
            en = 0;
            #1;

            check_outputs(7'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter_7bit Testbench");
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
        input [6:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, en, reset_n, q);
    end

endmodule
