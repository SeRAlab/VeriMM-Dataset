`timescale 1ns/1ps

module shift_register_6bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr_n;
    reg [5:0] d;
    reg en;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_6bit dut (
        .clk(clk),
        .clr_n(clr_n),
        .d(d),
        .en(en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clr_n = 0;
        en = 0;
        d = 0;
        #15;
        clr_n = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(6'b000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift in all ones", test_num);
        reset_dut();

        @(negedge clk);
        en = 1;
        d = 6'b000001;


        repeat(6) @(negedge clk);

        en = 0;
        #1;

        check_outputs(6'b111111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift alternating pattern 101010", test_num);
        reset_dut();

        @(negedge clk);
        en = 1;


        d = 1; @(negedge clk);
        d = 0; @(negedge clk);
        d = 1; @(negedge clk);
        d = 0; @(negedge clk);
        d = 1; @(negedge clk);
        d = 0; @(negedge clk);

        en = 0;
        #1;

        check_outputs(6'b101010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Enable signal check", test_num);
        reset_dut();

        @(negedge clk);
        en = 1; d = 1;
        repeat(2) @(negedge clk);

        en = 0; d = 0;
        repeat(3) @(negedge clk);

        en = 1; d = 1;
        @(negedge clk);

        en = 0;
        #1;

        check_outputs(6'b000111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Asynchronous clear check", test_num);
        reset_dut();

        @(negedge clk);
        en = 1; d = 1;
        repeat(4) @(negedge clk);


        #2 clr_n = 0;
        #2;

        #1;


        check_outputs(6'b000000);


        clr_n = 1;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_6bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        $dumpvars(0,clk, clr_n, d, en, q);
    end

endmodule
