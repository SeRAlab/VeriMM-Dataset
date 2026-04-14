`timescale 1ns/1ps

module InterruptController_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] active_irq;
    reg clk;
    reg rst;
    wire [1:0] highest_irq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    InterruptController dut (
        .active_irq(active_irq),
        .clk(clk),
        .rst(rst),
        .highest_irq(highest_irq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        active_irq = 4'b0000;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Interrupt 0 only", test_num);
        reset_dut();
        active_irq = 4'b0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Interrupt 1 only", test_num);
        reset_dut();
        active_irq = 4'b0010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Interrupt 2 only", test_num);
        reset_dut();
        active_irq = 4'b0100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Interrupt 3 only", test_num);
        reset_dut();
        active_irq = 4'b1000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Interrupt 0 and 3 active (Priority Check)", test_num);
        reset_dut();
        active_irq = 4'b1001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Interrupt 1 and 2 active (Priority Check)", test_num);
        reset_dut();
        active_irq = 4'b0110;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All interrupts active", test_num);
        reset_dut();
        active_irq = 4'b1111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Edge-triggered update check", test_num);
        reset_dut();


        active_irq = 4'b0100;
        @(posedge clk);
        #1;


        active_irq = 4'b0010;
        #2;



        @(posedge clk);
        #1;
        #1;

        check_outputs(2'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("InterruptController Testbench");
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
        input [1:0] expected_highest_irq;
        begin
            if (expected_highest_irq === (expected_highest_irq ^ highest_irq ^ expected_highest_irq)) begin
                $display("PASS");
                $display("  Outputs: highest_irq=%h",
                         highest_irq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: highest_irq=%h",
                         expected_highest_irq);
                $display("  Got:      highest_irq=%h",
                         highest_irq);
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
        $dumpvars(0,active_irq, clk, rst, highest_irq);
    end

endmodule
