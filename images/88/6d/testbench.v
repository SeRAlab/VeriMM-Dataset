`timescale 1ns/1ps

module counter_5bit_up_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [4:0] load_value;
    reg rst;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_5bit_up dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
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
            @(posedge clk);
            rst = 1;
            load = 0;
            load_value = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counting up for 10 cycles", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Loading value 5'h1A", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 5'h1A;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(5'h1A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 5'd5 and count up 3 times", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 5'd5;
            @(posedge clk);
            #1;
            load = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying rollover from 31 to 0", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 5'd31;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over Load", test_num);
            reset_dut();
            @(posedge clk);
            rst = 1;
            load = 1;
            load_value = 5'h1F;
            @(posedge clk);
            #1;
            rst = 0;
            load = 0;

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Continuous count for 35 cycles (should wrap)", test_num);
            reset_dut();
            repeat(35) @(posedge clk);
            #1;

            #1;


            check_outputs(5'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_5bit_up Testbench");
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
        input [4:0] expected_q;
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
        $dumpvars(0,clk, load, load_value, rst, q);
    end

endmodule
