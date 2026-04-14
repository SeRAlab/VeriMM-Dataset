`timescale 1ns/1ps

module decrementer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [9:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decrementer dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            rst = 1;
            #15;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify reset value (1023)", test_num);
            reset_dut();

            #1;


            check_outputs(10'd1023);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single decrement step", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            @(posedge clk);
            en = 0;
            #1;

            check_outputs(10'd1022);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement by 10 steps", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            en = 0;

            #1;


            check_outputs(10'd1013);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check enable signal low (no decrement)", test_num);
            reset_dut();
            @(posedge clk);
            en = 0;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow check (0 to 1023)", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;


            for (i = 0; i < 1024; i = i + 1) begin
                @(posedge clk);
            end
            en = 0;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous reset mid-operation", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            repeat (5) @(posedge clk);


            #3;
            rst = 1;
            #2;

            #1;


            check_outputs(10'd1023);
            rst = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggling enable every other cycle", test_num);
            reset_dut();

            @(posedge clk); en = 1;
            @(posedge clk); en = 0;
            @(posedge clk); en = 1;
            @(posedge clk); en = 0;
            @(posedge clk); en = 1;
            @(posedge clk); en = 0;

            #1;


            check_outputs(10'd1020);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decrementer Testbench");
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
        input [9:0] expected_count;
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
        $dumpvars(0,clk, en, rst, count);
    end

endmodule
