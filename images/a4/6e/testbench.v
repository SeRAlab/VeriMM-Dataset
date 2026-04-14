`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg enable;
    reg reset_n;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .dir(dir),
        .enable(enable),
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
            reset_n = 0;
            enable = 0;
            dir = 0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic Up Counting (10 cycles)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            dir = 1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Down Counting (Underflow/Wrap-around)", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            dir = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Synchronous Enable Control", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            dir = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Mid-operation Direction Change", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            dir = 1;
            repeat(10) @(posedge clk);
            dir = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0006);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Asynchronous Reset During Operation", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            dir = 1;
            repeat(8) @(posedge clk);
            #3;
            reset_n = 0;
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Counter Overflow (FFFF to 0000)", test_num);
            reset_dut();


            @(negedge clk);
            enable = 1;
            dir = 0;
            @(posedge clk);
            dir = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [15:0] expected_q;
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
        $dumpvars(0,clk, dir, enable, reset_n, q);
    end

endmodule
