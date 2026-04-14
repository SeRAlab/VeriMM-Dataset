`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg IRQ0;
    reg IRQ1;
    reg IRQ2;
    reg IRQ3;
    reg clk;
    wire [3:0] IRQ_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .IRQ0(IRQ0),
        .IRQ1(IRQ1),
        .IRQ2(IRQ2),
        .IRQ3(IRQ3),
        .clk(clk),
        .IRQ_OUT(IRQ_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        IRQ0 = 0;
        IRQ1 = 0;
        IRQ2 = 0;
        IRQ3 = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: IRQ0 only", test_num);
        reset_dut();
        IRQ0 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: IRQ2 only", test_num);
        reset_dut();
        IRQ2 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Multiple IRQs (0 and 1)", test_num);
        reset_dut();
        IRQ0 = 1;
        IRQ1 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Multiple IRQs (1 and 3)", test_num);
        reset_dut();
        IRQ1 = 1;
        IRQ3 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: All IRQs active", test_num);
        reset_dut();
        IRQ0 = 1;
        IRQ1 = 1;
        IRQ2 = 1;
        IRQ3 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: No IRQs active", test_num);
        reset_dut();
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: IRQ3 then IRQ2 (Sequential)", test_num);
        reset_dut();
        IRQ3 = 1;
        @(posedge clk);
        #1;
        IRQ2 = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(4'b0100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("interrupt_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_IRQ_OUT;
        begin
            if (expected_IRQ_OUT === (expected_IRQ_OUT ^ IRQ_OUT ^ expected_IRQ_OUT)) begin
                $display("PASS");
                $display("  Outputs: IRQ_OUT=%h",
                         IRQ_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IRQ_OUT=%h",
                         expected_IRQ_OUT);
                $display("  Got:      IRQ_OUT=%h",
                         IRQ_OUT);
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
        $dumpvars(0,IRQ0, IRQ1, IRQ2, IRQ3, clk, IRQ_OUT);
    end

endmodule
