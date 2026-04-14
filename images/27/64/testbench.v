`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg IRQ;
    reg clk;
    reg rst;
    wire IRQ_ACK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .IRQ(IRQ),
        .clk(clk),
        .rst(rst),
        .IRQ_ACK(IRQ_ACK)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            IRQ = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic IRQ assertion", test_num);
            reset_dut();
            IRQ = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: IRQ de-assertion clearing ACK", test_num);
            reset_dut();
            IRQ = 1;
            repeat(2) @(posedge clk);
            IRQ = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No IRQ signal", test_num);
            reset_dut();
            IRQ = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset during active IRQ", test_num);
            reset_dut();
            IRQ = 1;
            repeat(2) @(posedge clk);
            rst = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential interrupts", test_num);
            reset_dut();


            IRQ = 1;
            repeat(2) @(posedge clk);
            IRQ = 0;
            repeat(2) @(posedge clk);


            IRQ = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
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
        input expected_IRQ_ACK;
        begin
            if (expected_IRQ_ACK === (expected_IRQ_ACK ^ IRQ_ACK ^ expected_IRQ_ACK)) begin
                $display("PASS");
                $display("  Outputs: IRQ_ACK=%b",
                         IRQ_ACK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IRQ_ACK=%b",
                         expected_IRQ_ACK);
                $display("  Got:      IRQ_ACK=%b",
                         IRQ_ACK);
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
        $dumpvars(0,IRQ, clk, rst, IRQ_ACK);
    end

endmodule
