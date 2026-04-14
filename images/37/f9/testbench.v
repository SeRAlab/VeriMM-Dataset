`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] irq;
    reg rst;
    wire ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq(irq),
        .rst(rst),
        .ack(ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            irq = 3'b000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Highest Priority IRQ0", test_num);
            reset_dut();
            irq = 3'b001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Medium Priority IRQ1", test_num);
            reset_dut();
            irq = 3'b010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Lowest Priority IRQ2", test_num);
            reset_dut();
            irq = 3'b100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: No IRQ asserted", test_num);
            reset_dut();
            irq = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multiple IRQs (0 and 1)", test_num);
            reset_dut();
            irq = 3'b011;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple IRQs (1 and 2)", test_num);
            reset_dut();
            irq = 3'b110;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: All IRQs asserted", test_num);
            reset_dut();
            irq = 3'b111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: IRQ de-assertion timing", test_num);
            reset_dut();
            irq = 3'b001;
            @(posedge clk);
            #2;

            if (ack !== 1'b1) $display("  Intermediate Error: ack not 1");
            irq = 3'b000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_ack;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack)) begin
                $display("PASS");
                $display("  Outputs: ack=%b",
                         ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b",
                         expected_ack);
                $display("  Got:      ack=%b",
                         ack);
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
        $dumpvars(0,clk, irq, rst, ack);
    end

endmodule
