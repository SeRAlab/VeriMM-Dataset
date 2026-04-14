`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data;
    reg load;
    reg shift_enable;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data(data),
        .load(load),
        .shift_enable(shift_enable),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        load = 0;
        shift_enable = 0;
        data = 32'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Loading data 0xDEADBEEF", test_num);
        reset_dut();
        load = 1;
        data = 32'hDEADBEEF;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Load 0x2 and shift right once", test_num);
        reset_dut();

        load = 1;
        data = 32'h00000002;
        @(posedge clk);
        #1;

        load = 0;
        shift_enable = 1;
        @(posedge clk);
        #1;
        shift_enable = 0;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Load 0xF0000000 and shift right 4 times", test_num);
        reset_dut();

        load = 1;
        data = 32'hF0000000;
        @(posedge clk);
        #1;

        load = 0;
        shift_enable = 1;
        repeat(4) @(posedge clk);
        #1;
        shift_enable = 0;
        #1;

        check_outputs(32'h0F000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Load and Shift Enable both High", test_num);
        reset_dut();
        load = 1;
        shift_enable = 1;
        data = 32'h12345678;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Hold state (Enable=0, Load=0)", test_num);
        reset_dut();

        load = 1;
        data = 32'h5555AAAA;
        @(posedge clk);
        #1;

        load = 0;
        shift_enable = 0;
        data = 32'hFFFFFFFF;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(32'h5555AAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Shift right 32 times", test_num);
        reset_dut();
        load = 1;
        data = 32'hFFFFFFFF;
        @(posedge clk);
        #1;
        load = 0;
        shift_enable = 1;
        repeat(32) @(posedge clk);
        #1;
        shift_enable = 0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, data, load, shift_enable, q);
    end

endmodule
