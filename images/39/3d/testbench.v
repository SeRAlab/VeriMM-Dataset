`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] irq;
    reg rst;
    wire irq_ack;
    wire irq_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq(irq),
        .rst(rst),
        .irq_ack(irq_ack),
        .irq_out(irq_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            irq = 4'b0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Checking Idle State after Reset", test_num);

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Single IRQ0 Acknowledge Check", test_num);
            irq = 4'b0001;


            wait(irq_ack === 1'b1);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Single IRQ3 Completion (Ready) Check", test_num);
            irq = 4'b1000;

            wait(irq_ack === 1'b1);
            @(posedge clk);
            irq = 4'b0000;


            wait(ready === 1'b1);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Priority Scheme (Multiple IRQs)", test_num);
            irq = 4'b1011;


            wait(irq_ack === 1'b1);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Signal State During Processing", test_num);
            irq = 4'b0100;

            wait(irq_ack === 1'b1);
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_irq_ack;
        input expected_irq_out;
        input expected_ready;
        begin
            if (expected_irq_ack === (expected_irq_ack ^ irq_ack ^ expected_irq_ack) &&
                expected_irq_out === (expected_irq_out ^ irq_out ^ expected_irq_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: irq_ack=%b, irq_out=%b, ready=%b",
                         irq_ack, irq_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq_ack=%b, irq_out=%b, ready=%b",
                         expected_irq_ack, expected_irq_out, expected_ready);
                $display("  Got:      irq_ack=%b, irq_out=%b, ready=%b",
                         irq_ack, irq_out, ready);
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
        $dumpvars(0,clk, irq, rst, irq_ack, irq_out, ready);
    end

endmodule
