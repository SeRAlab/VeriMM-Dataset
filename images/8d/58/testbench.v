`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] data;
    reg enable;
    reg load;
    reg reset;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .data(data),
        .enable(enable),
        .load(load),
        .reset(reset),
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
            reset = 0;
            load = 0;
            enable = 0;
            data = 0;
            @(posedge clk);
            reset = 1;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset functionality", test_num);
            reset_dut();

            #1;


            check_outputs(6'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load functionality", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 6'h2A;
            @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(6'h2A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic countdown (3 steps)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 6'h0A;
            @(posedge clk);
            load = 0;
            enable = 1;
            repeat (3) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(6'h07);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counter disabled (Hold value)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 6'h15;
            @(posedge clk);
            load = 0;
            enable = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(6'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrap-around from 0 to 63", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 6'h01;
            @(posedge clk);
            load = 0;
            enable = 1;
            @(posedge clk);
            @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load priority over Enable", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            enable = 1;
            data = 6'h05;
            @(posedge clk);
            load = 0;
            enable = 0;
            #1;
            #1;

            check_outputs(6'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over Load", test_num);
            reset_dut();
            @(posedge clk);
            reset = 0;
            load = 1;
            data = 6'h10;
            @(posedge clk);
            reset = 1;
            load = 0;
            #1;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_counter Testbench");
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
        input [5:0] expected_q;
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
        $dumpvars(0,clk, data, enable, load, reset, q);
    end

endmodule
