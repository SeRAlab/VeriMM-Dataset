`timescale 1ns/1ps

module sync_down_counter_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [2:0] load_val;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_down_counter_with_load dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 1;
        load_val = 3'b000;
        @(posedge clk);
        #1;
        load = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Load (Value 7)", test_num);
        reset_dut();
        load = 1;
        load_val = 3'b111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single Decrement (5 -> 4)", test_num);
        reset_dut();
        load = 1;
        load_val = 3'b101;
        @(posedge clk);
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Underflow Check (0 -> 7)", test_num);
        reset_dut();

        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple Decrements (3 -> 0)", test_num);
        reset_dut();
        load = 1;
        load_val = 3'b011;
        @(posedge clk);
        load = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Load Priority Over Decrement", test_num);
        reset_dut();
        load = 1;
        load_val = 3'b110;
        @(posedge clk);

        load = 1;
        load_val = 3'b010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Full Cycle Decrement (8 steps)", test_num);
        reset_dut();
        load = 1;
        load_val = 3'b100;
        @(posedge clk);
        load = 0;
        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(3'b100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_down_counter_with_load Testbench");
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
        input [2:0] expected_q;
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
        $dumpvars(0,clk, load, load_val, q);
    end

endmodule
