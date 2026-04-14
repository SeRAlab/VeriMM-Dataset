`timescale 1ns/1ps

module accumulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg en;
    reg rst;
    wire [7:0] acc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    accumulator dut (
        .clk(clk),
        .d(d),
        .en(en),
        .rst(rst),
        .acc(acc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            d = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Reset and Zero Accumulation", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Accumulation (10 + 20 + 5)", test_num);
            reset_dut();

            @(negedge clk);
            en = 1; d = 8'd10;
            @(negedge clk);
            d = 8'd20;
            @(negedge clk);
            d = 8'd5;
            @(negedge clk);
            en = 0;


            #1;



            check_outputs(8'd35);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Signal Verification (Ignore d when en=0)", test_num);
            reset_dut();

            @(negedge clk);
            en = 1; d = 8'd50;
            @(negedge clk);
            en = 0; d = 8'd100;
            @(negedge clk);
            en = 1; d = 8'd5;
            @(negedge clk);
            en = 0;


            #1;



            check_outputs(8'd55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8-bit Overflow Wrap Around", test_num);
            reset_dut();

            @(negedge clk);
            en = 1; d = 8'hF0;
            @(negedge clk);
            d = 8'h20;
            @(negedge clk);
            en = 0;

            #1;


            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-operation Reset", test_num);
            reset_dut();

            @(negedge clk);
            en = 1; d = 8'd100;
            @(negedge clk);
            rst = 1;
            #2;

            #1;


            check_outputs(8'h00);


            @(negedge clk);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Adding Zero", test_num);
            reset_dut();

            @(negedge clk);
            en = 1; d = 8'd42;
            @(negedge clk);
            d = 8'd0;
            @(negedge clk);
            en = 0;

            #1;


            check_outputs(8'd42);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("accumulator Testbench");
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
        input [7:0] expected_acc;
        begin
            if (expected_acc === (expected_acc ^ acc ^ expected_acc)) begin
                $display("PASS");
                $display("  Outputs: acc=%h",
                         acc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acc=%h",
                         expected_acc);
                $display("  Got:      acc=%h",
                         acc);
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
        $dumpvars(0,clk, d, en, rst, acc);
    end

endmodule
