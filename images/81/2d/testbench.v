`timescale 1ns/1ps

module sync_up_counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] d;
    reg load;
    reg rst;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_up_counter_with_load dut (
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
            d = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset and check increment after 5 cycles", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'h0005);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Load value 0xABCD", test_num);
            reset_dut();
            d = 16'hABCD;
            load = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Load 0x1000 then increment for 10 cycles", test_num);
            reset_dut();
            d = 16'h1000;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(16'h100A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Verify wrap-around from 0xFFFF to 0x0000", test_num);
            reset_dut();
            d = 16'hFFFF;
            load = 1;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Verify Load priority over counting", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            d = 16'h5555;
            load = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Verify Reset priority over Load", test_num);
            reset_dut();
            d = 16'h1234;
            load = 1;
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Load 0xFFFE then check increment and wrap", test_num);
            reset_dut();
            d = 16'hFFFE;
            load = 1;
            @(posedge clk);
            load = 0;
            repeat(2) @(posedge clk);
            #1 #1;
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
        $display("sync_up_counter_with_load Testbench");
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
        $dumpvars(0,clk, d, load, rst, q);
    end

endmodule
