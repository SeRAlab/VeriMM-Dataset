`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg hpi;
    reg lpi;
    wire irq;
    wire [1:0] irq_type;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .ack(ack),
        .hpi(hpi),
        .lpi(lpi),
        .irq(irq),
        .irq_type(irq_type)
    );

    // Clock generation (10ns period)
    initial begin
        ack = 0;
        forever #5 ack = ~ack;
    end

        task reset_dut;

        begin
            hpi = 0;
            lpi = 0;


            @(negedge ack);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No interrupts", test_num);
            reset_dut();
            hpi = 0;
            lpi = 0;

            #2;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: HPI only", test_num);
            reset_dut();
            hpi = 1;
            lpi = 0;

            #2;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LPI only", test_num);
            reset_dut();
            hpi = 0;
            lpi = 1;

            #2;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Both HPI and LPI (HPI wins)", test_num);
            reset_dut();
            hpi = 1;
            lpi = 1;

            #2;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Acknowledge HPI", test_num);
            reset_dut();
            hpi = 1;
            lpi = 0;

            @(posedge ack);
            #2;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Acknowledge LPI", test_num);
            reset_dut();
            hpi = 0;
            lpi = 1;
            @(posedge ack);
            #2;
            #1;

            check_outputs(1'b0, 2'b00);
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
        input expected_irq;
        input [1:0] expected_irq_type;
        begin
            if (expected_irq === (expected_irq ^ irq ^ expected_irq) &&
                expected_irq_type === (expected_irq_type ^ irq_type ^ expected_irq_type)) begin
                $display("PASS");
                $display("  Outputs: irq=%b, irq_type=%h",
                         irq, irq_type);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq=%b, irq_type=%h",
                         expected_irq, expected_irq_type);
                $display("  Got:      irq=%b, irq_type=%h",
                         irq, irq_type);
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
        $dumpvars(0,ack, hpi, lpi, irq, irq_type);
    end

endmodule
