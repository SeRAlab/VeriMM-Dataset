`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] irq;
    reg rst;
    wire ack;
    wire irq_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .enable(enable),
        .irq(irq),
        .rst(rst),
        .ack(ack),
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
            enable = 0;
            irq = 4'b0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Idle State (No IRQs)", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b0000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single IRQ (Bit 0)", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b0001;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single IRQ (Bit 3)", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b1000;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Disabled Controller with IRQs", test_num);
            reset_dut();
            enable = 0;
            irq = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple IRQs (Bit 1 and 2)", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b0110;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All IRQs Active", test_num);
            reset_dut();
            enable = 1;
            irq = 4'b1111;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Toggling", test_num);
            reset_dut();
            irq = 4'b0010;
            enable = 0;
            @(posedge clk);
            #1;
            if (irq_out == 0 && ack == 0) begin
                enable = 1;
                @(posedge clk);
                #1 #1;
 check_outputs(1'b1, 1'b1);
            end else begin
                #1;

                check_outputs(1'b0, 1'b0);
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
        input expected_irq_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_irq_out === (expected_irq_out ^ irq_out ^ expected_irq_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, irq_out=%b",
                         ack, irq_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, irq_out=%b",
                         expected_ack, expected_irq_out);
                $display("  Got:      ack=%b, irq_out=%b",
                         ack, irq_out);
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
        $dumpvars(0,clk, enable, irq, rst, ack, irq_out);
    end

endmodule
