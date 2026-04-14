`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] irq;
    reg reset;
    wire [1:0] highest_priority;
    wire int_ack;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq(irq),
        .reset(reset),
        .highest_priority(highest_priority),
        .int_ack(int_ack)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            irq = 4'b0000;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: No IRQs active", test_num);
            irq = 4'b0000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: IRQ0 only", test_num);
            irq = 4'b0001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: IRQ3 only", test_num);
            irq = 4'b1000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Multiple IRQs (3 and 0), 3 should win", test_num);
            irq = 4'b1001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Multiple IRQs (2 and 1), 2 should win", test_num);
            irq = 4'b0110;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: All IRQs active, 3 should win", test_num);
            irq = 4'b1111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Reset while IRQ is high", test_num);
            irq = 4'b0100;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(2'b00, 1'b0);
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
        input [1:0] expected_highest_priority;
        input expected_int_ack;
        begin
            if (expected_highest_priority === (expected_highest_priority ^ highest_priority ^ expected_highest_priority) &&
                expected_int_ack === (expected_int_ack ^ int_ack ^ expected_int_ack)) begin
                $display("PASS");
                $display("  Outputs: highest_priority=%h, int_ack=%b",
                         highest_priority, int_ack);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: highest_priority=%h, int_ack=%b",
                         expected_highest_priority, expected_int_ack);
                $display("  Got:      highest_priority=%h, int_ack=%b",
                         highest_priority, int_ack);
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
        $dumpvars(0,clk, irq, reset, highest_priority, int_ack);
    end

endmodule
