`timescale 1ns/1ps

module PIPO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data;
    reg load;
    reg reset;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PIPO_Shift_Register dut (
        .clk(clk),
        .data(data),
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
        reset = 1;
        load = 0;
        data = 0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial Reset Verification", test_num);
        reset_dut();
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Parallel Load (All 1s)", test_num);
        reset_dut();
        data = 5'b11111;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Parallel Load (Pattern 10101)", test_num);
        reset_dut();
        data = 5'b10101;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift Operation - Single Step", test_num);
        reset_dut();
        data = 5'b11111;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b01111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple Shift Operations", test_num);
        reset_dut();
        data = 5'b10111;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b00010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift until Empty", test_num);
        reset_dut();
        data = 5'b11111;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Interleaved Load and Shift", test_num);
        reset_dut();
        data = 5'b10000;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
        data = 5'b11011;
        load = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b11011);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Asynchronous Reset During Shift", test_num);
        reset_dut();
        data = 5'b11111;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PIPO_Shift_Register Testbench");
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
        $dumpvars(0,clk, data, load, reset, q);
    end

endmodule
