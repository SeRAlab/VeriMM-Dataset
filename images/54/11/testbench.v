`timescale 1ns/1ps

module counter_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [7:0] load_value;
    reg reset;
    wire [7:0] counter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_8bit dut (
        .clk(clk),
        .en(en),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .counter_out(counter_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        en = 0;
        load = 0;
        load_value = 8'h00;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load Value 8'hA5", test_num);
        reset_dut();
        load = 1;
        load_value = 8'hA5;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Count up 10 times", test_num);
        reset_dut();
        en = 1;
        repeat (10) @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load 8'h10 then count 5 times", test_num);
        reset_dut();
        load = 1;
        load_value = 8'h10;
        @(posedge clk);
        #1;
        load = 0;
        en = 1;
        repeat (5) @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(8'h15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Counter Overflow (FF to 00)", test_num);
        reset_dut();
        load = 1;
        load_value = 8'hFE;
        @(posedge clk);
        #1;
        load = 0;
        en = 1;
        repeat (2) @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Disable Enable (Hold Value)", test_num);
        reset_dut();
        load = 1;
        load_value = 8'h55;
        @(posedge clk);
        #1;
        load = 0;
        en = 0;
        repeat (5) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load Priority over Enable", test_num);
        reset_dut();
        load = 1;
        en = 1;
        load_value = 8'hCC;
        @(posedge clk);
        #1;

        #1;


        check_outputs(8'hCC);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority over Load/Enable", test_num);
        reset_dut();

        load = 1;
        load_value = 8'hAA;
        en = 1;

        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_8bit Testbench");
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
        input [7:0] expected_counter_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h",
                         counter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h",
                         expected_counter_out);
                $display("  Got:      counter_out=%h",
                         counter_out);
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
        $dumpvars(0,clk, en, load, load_value, reset, counter_out);
    end

endmodule
