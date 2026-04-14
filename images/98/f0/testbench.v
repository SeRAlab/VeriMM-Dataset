`timescale 1ns/1ps

module reg_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg load;
    reg rst_n;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_16bit dut (
        .clk(clk),
        .d(d),
        .load(load),
        .rst_n(rst_n),
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
            rst_n = 0;
            load = 0;
            d = 16'h0000;
            @(negedge clk);
            rst_n = 1;
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Data Load (0xAAAA)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 16'hAAAA;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Persistence (Load=0)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            d = 16'h1234;
            @(negedge clk);

            load = 0;
            d = 16'hFFFF;
            @(negedge clk);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Priority over Load", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 16'h5555;
            rst_n = 0;
            @(negedge clk);
            rst_n = 1;
            load = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Sequential Loads", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 16'h1111;
            @(negedge clk);
            d = 16'h2222;
            @(negedge clk);
            d = 16'h3333;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load All Ones (0xFFFF)", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            d = 16'hFFFF;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_16bit Testbench");
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
        $dumpvars(0,clk, d, load, rst_n, q);
    end

endmodule
