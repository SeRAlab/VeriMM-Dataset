`timescale 1ns/1ps

module gated_d_flip_flop_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg clk;
    reg clk_en;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gated_d_flip_flop dut (
        .D(D),
        .clk(clk),
        .clk_en(clk_en),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        clk_en = 1;
        D = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Write 1 with clk_en=1", test_num);
        reset_dut();

        @(negedge clk);
        clk_en = 1;
        D = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Ignore D change with clk_en=0", test_num);
        reset_dut();

        @(negedge clk);
        clk_en = 0;
        D = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load 1 then verify Hold", test_num);
        reset_dut();


        @(negedge clk);
        clk_en = 1;
        D = 1;
        @(posedge clk);


        @(negedge clk);
        clk_en = 0;
        D = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential data updates 0 -> 1 -> 0", test_num);
        reset_dut();


        @(negedge clk);
        clk_en = 1;
        D = 1;
        @(posedge clk);


        @(negedge clk);
        clk_en = 1;
        D = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: D instability while clk_en=0", test_num);
        reset_dut();


        @(negedge clk);
        clk_en = 1;
        D = 1;
        @(posedge clk);


        @(negedge clk);
        clk_en = 0;
        D = 0; #2;
        D = 1; #2;
        D = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gated_d_flip_flop Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,D, clk, clk_en, Q);
    end

endmodule
