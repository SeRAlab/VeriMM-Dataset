`timescale 1ns/1ps

module clock_gating_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg enable;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gating dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .q(q)
    );

        task reset_dut;

        begin
            d = 0;
            enable = 1;
            @(negedge clk);
            d = 0;
            @(negedge clk);
            enable = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Normal Operation - Write 1 (Enable=1)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            d = 1;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Normal Operation - Write 0 (Enable=1)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            d = 1;
            @(negedge clk);
            d = 0;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Clock Gating - Block 1 (Enable=0)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 0;
            d = 1;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Clock Gating - Hold 1 (Enable=0)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            d = 1;
            @(negedge clk);
            enable = 0;
            d = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Re-enable clock after gating", test_num);
            reset_dut();
            @(negedge clk);
            enable = 0;
            d = 1;
            @(negedge clk);
            enable = 1;
            @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data noise while gated", test_num);
            reset_dut();
            @(negedge clk);
            enable = 0;
            d = 1; #2; d = 0; #2; d = 1;
            @(negedge clk);
            d = 0; #1; d = 1;
            @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_gating Testbench");
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,clk, d, enable, q);
    end

endmodule
