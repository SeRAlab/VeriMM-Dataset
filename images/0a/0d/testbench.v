`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg new_bit;
    reg reset;
    wire [15:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .new_bit(new_bit),
        .reset(reset),
        .shift_reg(shift_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        $display("Resetting DUT...");
        reset = 1;
        new_bit = 0;
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
        $display("\nTestcase %0d: Verify Reset", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Shift in 4 bits (1101)", test_num);
        reset_dut();


        new_bit = 1; @(posedge clk); #1;
        new_bit = 1; @(posedge clk); #1;
        new_bit = 0; @(posedge clk); #1;
        new_bit = 1; @(posedge clk); #1;


        #1;



        check_outputs(16'h000D);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Fill register with 1s", test_num);
        reset_dut();

        new_bit = 1;
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            #1;
        end

        #1;


        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating pattern 1010...", test_num);
        reset_dut();

        for (i = 0; i < 8; i = i + 1) begin
            new_bit = 1; @(posedge clk); #1;
            new_bit = 0; @(posedge clk); #1;
        end

        #1;


        check_outputs(16'hAAAA);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Overflow check (17 bits)", test_num);
        reset_dut();


        new_bit = 1;
        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk); #1;
        end

        new_bit = 0;
        @(posedge clk); #1;


        #1;



        check_outputs(16'hFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Mid-operation Reset", test_num);
        reset_dut();


        new_bit = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;


        reset = 1;
        @(posedge clk); #1;
        reset = 0;

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
        input [15:0] expected_shift_reg;
        begin
            if (expected_shift_reg === (expected_shift_reg ^ shift_reg ^ expected_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: shift_reg=%h",
                         shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shift_reg=%h",
                         expected_shift_reg);
                $display("  Got:      shift_reg=%h",
                         shift_reg);
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
        $dumpvars(0,clk, new_bit, reset, shift_reg);
    end

endmodule
