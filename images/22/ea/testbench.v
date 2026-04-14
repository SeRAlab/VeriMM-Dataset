`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] irq;
    reg reset;
    wire [2:0] irq_serviced;
    wire irq_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .irq(irq),
        .reset(reset),
        .irq_serviced(irq_serviced),
        .irq_valid(irq_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            irq = 8'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Idle State", test_num);
            reset_dut();
            irq = 8'b0000_0000;
            @(posedge clk);
            #1 #1;
 check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single IRQ (Bit 0)", test_num);
            reset_dut();
            irq = 8'b0000_0001;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single IRQ (Bit 7)", test_num);
            reset_dut();
            irq = 8'b1000_0000;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Resolution (0 and 7)", test_num);
            reset_dut();
            irq = 8'b1000_0001;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Mid-range IRQs (1, 3, 5)", test_num);
            reset_dut();
            irq = 8'b0010_1010;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All IRQs Active", test_num);
            reset_dut();
            irq = 8'b1111_1111;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dynamic Priority Update", test_num);
            reset_dut();
            irq = 8'b0000_0100;
            @(posedge clk);
            irq = 8'b0100_0100;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd6, 1'b1);
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
        input [2:0] expected_irq_serviced;
        input expected_irq_valid;
        begin
            if (expected_irq_serviced === (expected_irq_serviced ^ irq_serviced ^ expected_irq_serviced) &&
                expected_irq_valid === (expected_irq_valid ^ irq_valid ^ expected_irq_valid)) begin
                $display("PASS");
                $display("  Outputs: irq_serviced=%h, irq_valid=%b",
                         irq_serviced, irq_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: irq_serviced=%h, irq_valid=%b",
                         expected_irq_serviced, expected_irq_valid);
                $display("  Got:      irq_serviced=%h, irq_valid=%b",
                         irq_serviced, irq_valid);
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
        $dumpvars(0,clk, irq, reset, irq_serviced, irq_valid);
    end

endmodule
