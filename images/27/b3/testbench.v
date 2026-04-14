`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [2:0] irq;
    reg rst_n;
    wire [2:0] int_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .ack(ack),
        .clk(clk),
        .irq(irq),
        .rst_n(rst_n),
        .int_out(int_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            irq = 3'b000;
            ack = 0;
            repeat (2) @(posedge clk);
            #1 rst_n = 1;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            irq = 3'b001;
            repeat (2) @(posedge clk);
            $display("Testcase %0d: Testing highest priority irq[0]", test_num);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            irq = 3'b010;
            repeat (2) @(posedge clk);
            $display("Testcase %0d: Testing medium priority irq[1]", test_num);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            irq = 3'b100;
            repeat (2) @(posedge clk);
            $display("Testcase %0d: Testing lowest priority irq[2]", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            irq = 3'b111;
            repeat (2) @(posedge clk);
            $display("Testcase %0d: Testing priority arbitration (All IRQs active)", test_num);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            irq = 3'b110;
            repeat (2) @(posedge clk);
            $display("Testcase %0d: Testing priority arbitration (irq[1] and irq[2])", test_num);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            irq = 3'b001;
            repeat (2) @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
            irq = 3'b000;
            repeat (1) @(posedge clk);
            $display("Testcase %0d: Testing acknowledge clearing the output", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            irq = 3'b101;
            repeat (2) @(posedge clk);
            ack = 1;
            @(posedge clk);
            ack = 0;
            irq = 3'b100;
            repeat (2) @(posedge clk);
            $display("Testcase %0d: Testing sequential interrupt handling", test_num);
            #1;

            check_outputs(3'b100);
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
        input [2:0] expected_int_out;
        begin
            if (expected_int_out === (expected_int_out ^ int_out ^ expected_int_out)) begin
                $display("PASS");
                $display("  Outputs: int_out=%h",
                         int_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_out=%h",
                         expected_int_out);
                $display("  Got:      int_out=%h",
                         int_out);
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
        $dumpvars(0,ack, clk, irq, rst_n, int_out);
    end

endmodule
