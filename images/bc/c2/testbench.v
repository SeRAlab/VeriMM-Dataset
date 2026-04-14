`timescale 1ns/1ps

module down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] data;
    reg load;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_counter dut (
        .clk(clk),
        .data(data),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load <= 1;
        data <= 6'b101010;
        @(posedge clk);
        #1;
        load <= 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Synchronous Load", test_num);
        reset_dut();

        #1;


        check_outputs(6'b101010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Single Decrement", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(6'b101001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Multiple Decrements (10 cycles)", test_num);
        reset_dut();
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(6'b100000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Count to Zero", test_num);
        reset_dut();
        repeat(42) @(posedge clk);
        #1;
        #1;

        check_outputs(6'b000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Wrap-around logic", test_num);
        reset_dut();
        repeat(43) @(posedge clk);
        #1;
        #1;

        check_outputs(6'b111111);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Load Priority/Persistent Load", test_num);
        reset_dut();
        load <= 1;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(6'b101010);
        load <= 0;
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
        $dumpvars(0,clk, data, load, q);
    end

endmodule
