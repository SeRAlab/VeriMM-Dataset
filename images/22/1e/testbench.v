`timescale 1ns/1ps

module Register8Bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_en;
    reg [7:0] d;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Register8Bit dut (
        .clk(clk),
        .clk_en(clk_en),
        .d(d),
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
        clk_en = 0;
        d = 0;
        #15;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Functionality", test_num);
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Load Operation", test_num);
        reset_dut();

        @(posedge clk);
        clk_en = 1;
        d = 8'hA5;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Clock Enable (Inhibit Loading)", test_num);
        reset_dut();


        @(posedge clk);
        clk_en = 1;
        d = 8'h55;
        @(posedge clk);


        #1;
        clk_en = 0;
        d = 8'hAA;

        @(posedge clk);
        #1;

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous Reset Priority", test_num);
        reset_dut();


        @(posedge clk);
        clk_en = 1;
        d = 8'hFF;


        #3;
        rst = 1;
        #2;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Consecutive Loads", test_num);
        reset_dut();

        clk_en = 1;

        @(posedge clk);
        d = 8'h11;
        @(posedge clk);
        d = 8'h22;
        @(posedge clk);
        d = 8'h33;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Values (All 1s)", test_num);
        reset_dut();

        @(posedge clk);
        clk_en = 1;
        d = 8'hFF;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Register8Bit Testbench");
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, clk_en, d, rst, q);
    end

endmodule
