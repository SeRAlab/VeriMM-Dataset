`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg [3:0] irq;
    wire int_active;
    wire [3:0] int_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .ack(ack),
        .irq(irq),
        .int_active(int_active),
        .int_out(int_out)
    );

    // Clock generation (10ns period)
    initial begin
        ack = 0;
        forever #5 ack = ~ack;
    end

        task reset_dut;

    begin
        irq = 4'b0000;

        repeat(2) @(posedge ack);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %03d: No Interrupts", test_num);
        reset_dut();
        irq = 4'b0000;
        @(posedge ack);
        #2;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %03d: Single Interrupt (IRQ0)", test_num);
        reset_dut();
        @(negedge ack);
        irq = 4'b0001;
        @(posedge ack);
        #2;
        #1;

        check_outputs(1'b1, 4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %03d: Single Interrupt (IRQ3)", test_num);
        reset_dut();
        @(negedge ack);
        irq = 4'b1000;
        @(posedge ack);
        #2;
        #1;

        check_outputs(1'b1, 4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %03d: Multiple Interrupts (0 and 1)", test_num);
        reset_dut();
        @(negedge ack);
        irq = 4'b0011;
        @(posedge ack);
        #2;

        #1;


        check_outputs(1'b1, 4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %03d: Multiple Interrupts (1 and 2)", test_num);
        reset_dut();
        @(negedge ack);
        irq = 4'b0110;
        @(posedge ack);
        #2;

        #1;


        check_outputs(1'b1, 4'b0010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %03d: Multiple Interrupts (2 and 3)", test_num);
        reset_dut();
        @(negedge ack);
        irq = 4'b1100;
        @(posedge ack);
        #2;

        #1;


        check_outputs(1'b1, 4'b0100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running Testcase %03d: All Interrupts Active", test_num);
        reset_dut();
        @(negedge ack);
        irq = 4'b1111;
        @(posedge ack);
        #2;

        #1;


        check_outputs(1'b1, 4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Running Testcase %03d: Sequential Clearing", test_num);
        reset_dut();
        @(negedge ack);
        irq = 4'b0101;
        @(posedge ack);
        #2;
        if (int_out == 4'b0001) begin

            irq = 4'b0100;
            @(posedge ack);
            #2;
            #1;

            check_outputs(1'b1, 4'b0100);
        end else begin
            $display("Sequential sub-test failed: IRQ0 not prioritized");
            fail_count = fail_count + 1;
        end
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
        input expected_int_active;
        input [3:0] expected_int_out;
        begin
            if (expected_int_active === (expected_int_active ^ int_active ^ expected_int_active) &&
                expected_int_out === (expected_int_out ^ int_out ^ expected_int_out)) begin
                $display("PASS");
                $display("  Outputs: int_active=%b, int_out=%h",
                         int_active, int_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_active=%b, int_out=%h",
                         expected_int_active, expected_int_out);
                $display("  Got:      int_active=%b, int_out=%h",
                         int_active, int_out);
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
        $dumpvars(0,ack, irq, int_active, int_out);
    end

endmodule
