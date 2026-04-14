`timescale 1ns/1ps

module MICRO_PROG_COUNTER_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] AR_ROM_IN;
    reg CLEAR_MICRO;
    reg INC_MICRO;
    reg LOAD_MICRO;
    reg clk;
    reg rst;
    wire [4:0] PRE_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MICRO_PROG_COUNTER dut (
        .AR_ROM_IN(AR_ROM_IN),
        .CLEAR_MICRO(CLEAR_MICRO),
        .INC_MICRO(INC_MICRO),
        .LOAD_MICRO(LOAD_MICRO),
        .clk(clk),
        .rst(rst),
        .PRE_OUT(PRE_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        AR_ROM_IN = 5'b0;
        LOAD_MICRO = 0;
        INC_MICRO = 0;
        CLEAR_MICRO = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: System Reset", test_num);
        reset_dut();

        #1;


        check_outputs(5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Basic Increment", test_num);
        reset_dut();
        INC_MICRO = 1;
        @(posedge clk);
        INC_MICRO = 0;
        #1;
        #1;

        check_outputs(5'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Multiple Increments", test_num);
        reset_dut();
        INC_MICRO = 1;
        repeat(5) @(posedge clk);
        INC_MICRO = 0;
        #1;
        #1;

        check_outputs(5'h05);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Direct Load", test_num);
        reset_dut();
        AR_ROM_IN = 5'h1A;
        LOAD_MICRO = 1;
        @(posedge clk);
        LOAD_MICRO = 0;
        #1;
        #1;

        check_outputs(5'h1A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Clear via Control Signal", test_num);
        reset_dut();

        INC_MICRO = 1;
        repeat(3) @(posedge clk);

        INC_MICRO = 0;
        CLEAR_MICRO = 1;
        @(posedge clk);
        CLEAR_MICRO = 0;
        #1;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Hold Value", test_num);
        reset_dut();
        INC_MICRO = 1;
        repeat(4) @(posedge clk);
        INC_MICRO = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(5'h04);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Priority - Load over Increment", test_num);
        reset_dut();
        AR_ROM_IN = 5'h0F;
        LOAD_MICRO = 1;
        INC_MICRO = 1;
        @(posedge clk);
        LOAD_MICRO = 0;
        INC_MICRO = 0;
        #1;
        #1;

        check_outputs(5'h0F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Counter Wrap-around", test_num);
        reset_dut();
        AR_ROM_IN = 5'h1F;
        LOAD_MICRO = 1;
        @(posedge clk);
        LOAD_MICRO = 0;
        INC_MICRO = 1;
        @(posedge clk);
        INC_MICRO = 0;
        #1;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: Increment after Load", test_num);
        reset_dut();
        AR_ROM_IN = 5'h10;
        LOAD_MICRO = 1;
        @(posedge clk);
        LOAD_MICRO = 0;
        INC_MICRO = 1;
        @(posedge clk);
        INC_MICRO = 0;
        #1;
        #1;

        check_outputs(5'h11);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MICRO_PROG_COUNTER Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [4:0] expected_PRE_OUT;
        begin
            if (expected_PRE_OUT === (expected_PRE_OUT ^ PRE_OUT ^ expected_PRE_OUT)) begin
                $display("PASS");
                $display("  Outputs: PRE_OUT=%h",
                         PRE_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PRE_OUT=%h",
                         expected_PRE_OUT);
                $display("  Got:      PRE_OUT=%h",
                         PRE_OUT);
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
        $dumpvars(0,AR_ROM_IN, CLEAR_MICRO, INC_MICRO, LOAD_MICRO, clk, rst, PRE_OUT);
    end

endmodule
