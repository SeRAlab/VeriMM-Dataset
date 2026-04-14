`timescale 1ns/1ps

module counter6bit_en_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [5:0] load_value;
    reg rst;
    wire [5:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter6bit_en_load dut (
        .clk(clk),
        .en(en),
        .load(load),
        .load_value(load_value),
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
            rst = 1;
            en = 0;
            load = 0;
            load_value = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Incrementing with Enable", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load functionality", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 6'h2A;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(6'h2A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Increment after loading a value", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 6'd10;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd13);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Counter rollover", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 6'd63;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Hold value when Enable is low", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            repeat (2) @(posedge clk);
            #1 en = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(6'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Load priority over Enable", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            en = 1;
            load_value = 6'h1F;
            @(posedge clk);
            #1;

            #1;


            check_outputs(6'h1F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter6bit_en_load Testbench");
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
        input [5:0] expected_count;
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
        $dumpvars(0,clk, en, load, load_value, rst, count);
    end

endmodule
