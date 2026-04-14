`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg irq0;
    reg irq1;
    reg irq2;
    reg irq3;
    reg rst;
    wire irq_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .ack(ack),
        .clk(clk),
        .irq0(irq0),
        .irq1(irq1),
        .irq2(irq2),
        .irq3(irq3),
        .rst(rst),
        .irq_out(irq_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ack = 0;
            irq0 = 0;
            irq1 = 0;
            irq2 = 0;
            irq3 = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No interrupts active", test_num);
            reset_dut();

            irq0 = 0; irq1 = 0; irq2 = 0; irq3 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single low priority interrupt (irq0)", test_num);
            reset_dut();

            irq0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single high priority interrupt (irq3)", test_num);
            reset_dut();

            irq3 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority check - ack high priority, low remains", test_num);
            reset_dut();

            irq2 = 1;
            irq3 = 1;
            @(posedge clk);
            #1;

            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;
            irq3 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Acknowledge clearing the only interrupt", test_num);
            reset_dut();

            irq1 = 1;
            @(posedge clk);
            #1;
            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;
            irq1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential clearing of all interrupts", test_num);
            reset_dut();

            irq0 = 1; irq1 = 1; irq2 = 1; irq3 = 1;
            @(posedge clk);
            #1;


            ack = 1; @(posedge clk); #1; ack = 0; irq3 = 0;

            ack = 1; @(posedge clk); #1; ack = 0; irq2 = 0;

            ack = 1; @(posedge clk); #1; ack = 0; irq1 = 0;

            ack = 1; @(posedge clk); #1; ack = 0; irq0 = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interrupt during reset", test_num);


            rst = 1;
            irq3 = 1;
            #20;
            rst = 0;
            @(posedge clk);
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
        input expected_irq_out;
        begin
            if (expected_irq_out === (expected_irq_out ^ irq_out ^ expected_irq_out)) begin
                $display("PASS");
                $display("  Outputs: irq_out=%b",
                         irq_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq_out=%b",
                         expected_irq_out);
                $display("  Got:      irq_out=%b",
                         irq_out);
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
        $dumpvars(0,ack, clk, irq0, irq1, irq2, irq3, rst, irq_out);
    end

endmodule
