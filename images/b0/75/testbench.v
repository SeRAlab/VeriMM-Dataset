`timescale 1ns/1ps

module shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst_n;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg dut (
        .clk(clk),
        .data_in(data_in),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        data_in = 0;
        @(negedge clk);
        rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset verification", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Shift in sequence 1-0-1-1", test_num);
        reset_dut();


        data_in = 1; @(posedge clk);
        data_in = 0; @(posedge clk);
        data_in = 1; @(posedge clk);
        data_in = 1; @(posedge clk);

        #1;
        #1;

        check_outputs(16'h000B);
    end
        endtask

    task testcase003;

    integer i;
    reg [15:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Fill register with AAAAh", test_num);
        reset_dut();
        pattern = 16'hAAAA;

        for (i = 15; i >= 0; i = i - 1) begin
            data_in = pattern[i];
            @(posedge clk);
        end

        #1;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase004;

    integer i;
    reg [15:0] pattern;
    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Fill register with 5555h", test_num);
        reset_dut();
        pattern = 16'h5555;

        for (i = 15; i >= 0; i = i - 1) begin
            data_in = pattern[i];
            @(posedge clk);
        end

        #1;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overflow check (Shift in 17 bits)", test_num);
        reset_dut();


        data_in = 1;
        repeat(16) @(posedge clk);

        data_in = 0; @(posedge clk);

        #1;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-operation Reset", test_num);
        reset_dut();

        data_in = 1; repeat(5) @(posedge clk);
        rst_n = 0; #20; rst_n = 1;
        @(posedge clk);

        #1;
        #1;

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
        $display("shift_reg Testbench");
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
        input [15:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, data_in, rst_n, Q);
    end

endmodule
