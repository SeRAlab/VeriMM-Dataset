`timescale 1ns/1ps

module cache_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg control;
    wire [1:0] replace_line;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cache_controller dut (
        .addr(addr),
        .clk(clk),
        .control(control),
        .replace_line(replace_line)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            addr = 4'h0;
            control = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FIFO Basic Replacement", test_num);
            reset_dut();
            control = 0;

            @(negedge clk) addr = 4'h1;
            @(negedge clk) addr = 4'h2;
            @(negedge clk) addr = 4'h3;
            @(negedge clk) addr = 4'h4;
            @(negedge clk) addr = 4'h5;

            @(posedge clk); #2;
            #1;

            check_outputs(2'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LRU Basic Hit Update", test_num);
            reset_dut();
            control = 1;

            @(negedge clk) addr = 4'h1;
            @(negedge clk) addr = 4'h2;
            @(negedge clk) addr = 4'h3;
            @(negedge clk) addr = 4'h4;
            @(negedge clk) addr = 4'h1;
            @(negedge clk) addr = 4'hA;

            @(posedge clk); #2;
            #1;

            check_outputs(2'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FIFO Hit Invariance", test_num);
            reset_dut();
            control = 0;

            @(negedge clk) addr = 4'h1;
            @(negedge clk) addr = 4'h2;
            @(negedge clk) addr = 4'h3;
            @(negedge clk) addr = 4'h4;
            @(negedge clk) addr = 4'h1;
            @(negedge clk) addr = 4'hB;

            @(posedge clk); #2;
            #1;

            check_outputs(2'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LRU Complex Sequence", test_num);
            reset_dut();
            control = 1;

            @(negedge clk) addr = 4'h1;
            @(negedge clk) addr = 4'h2;
            @(negedge clk) addr = 4'h3;
            @(negedge clk) addr = 4'h4;
            @(negedge clk) addr = 4'h1;
            @(negedge clk) addr = 4'h2;
            @(negedge clk) addr = 4'hF;

            @(posedge clk); #2;
            #1;

            check_outputs(2'h2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: LRU Reverse Access", test_num);
            reset_dut();
            control = 1;

            @(negedge clk) addr = 4'h1;
            @(negedge clk) addr = 4'h2;
            @(negedge clk) addr = 4'h3;
            @(negedge clk) addr = 4'h4;
            @(negedge clk) addr = 4'h4;
            @(negedge clk) addr = 4'h3;
            @(negedge clk) addr = 4'h2;
            @(negedge clk) addr = 4'h1;
            @(negedge clk) addr = 4'h9;

            @(posedge clk); #2;
            #1;

            check_outputs(2'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cache_controller Testbench");
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
        input [1:0] expected_replace_line;
        begin
            if (expected_replace_line === (expected_replace_line ^ replace_line ^ expected_replace_line)) begin
                $display("PASS");
                $display("  Outputs: replace_line=%h",
                         replace_line);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: replace_line=%h",
                         expected_replace_line);
                $display("  Got:      replace_line=%h",
                         replace_line);
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
        $dumpvars(0,addr, clk, control, replace_line);
    end

endmodule
