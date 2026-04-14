`timescale 1ns/1ps

module counter16bit_up_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [15:0] load_val;
    reg rst;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter16bit_up dut (
        .clk(clk),
        .en(en),
        .load(load),
        .load_val(load_val),
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
            en = 0;
            load = 0;
            load_val = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset functionality", test_num);
            reset_dut();
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic counting (en=1)", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(16'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable control (en=0)", test_num);
            reset_dut();
            en = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load functionality", test_num);
            reset_dut();
            load = 1;
            load_val = 16'hA5A5;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count from loaded value", test_num);
            reset_dut();
            load = 1;
            load_val = 16'h1000;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'h1005);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rollover handling", test_num);
            reset_dut();
            load = 1;
            load_val = 16'hFFFF;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load priority over enable", test_num);
            reset_dut();
            load = 1;
            load_val = 16'h7777;
            en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h7777);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complex sequence", test_num);
            reset_dut();


            load = 1;
            load_val = 16'hEEEE;
            @(posedge clk);
            #1 load = 0;


            en = 1;
            repeat(2) @(posedge clk);


            #1 en = 0;
            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(16'hEEF0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter16bit_up Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, en, load, load_val, rst, q);
    end

endmodule
