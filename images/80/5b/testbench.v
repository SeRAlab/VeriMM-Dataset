`timescale 1ns/1ps

module counter7bit_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] d;
    reg load;
    reg rst;
    wire [6:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter7bit_load dut (
        .clk(clk),
        .d(d),
        .load(load),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            d = 7'b0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset functionality check", test_num);
            reset_dut();

            #1;


            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Increment check (10 cycles)", test_num);
            reset_dut();

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load functionality check", test_num);
            reset_dut();
            d = 7'd55;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(7'd55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load then increment check", test_num);
            reset_dut();
            d = 7'd100;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd105);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rollover check (127 to 0)", test_num);
            reset_dut();
            d = 7'd126;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load override check", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            d = 7'd20;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(7'd20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter7bit_load Testbench");
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
        $dumpvars(0,clk, d, load, rst, q);
    end

endmodule
