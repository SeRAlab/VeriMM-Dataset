`timescale 1ns/1ps

module InterruptController_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [3:0] irq;
    reg rst;
    wire [1:0] service;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    InterruptController dut (
        .ack(ack),
        .clk(clk),
        .irq(irq),
        .rst(rst),
        .service(service)
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
            irq = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single IRQ 0", test_num);
            reset_dut();
            irq = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single IRQ 1", test_num);
            reset_dut();
            irq = 4'b0010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single IRQ 2", test_num);
            reset_dut();
            irq = 4'b0100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single IRQ 3", test_num);
            reset_dut();
            irq = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (IRQ 0 and 1)", test_num);
            reset_dut();
            irq = 4'b0011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (IRQ 0, 1, 2)", test_num);
            reset_dut();
            irq = 4'b0111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (All IRQs active)", test_num);
            reset_dut();
            irq = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sequential Ack Handling", test_num);
            reset_dut();


            irq = 4'b1010;
            @(posedge clk);
            #1;


            ack = 1;
            @(posedge clk);
            #1;
            ack = 0;
            irq = 4'b0010;

            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Non-contiguous IRQs (0 and 3)", test_num);
            reset_dut();
            irq = 4'b1001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("InterruptController Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [1:0] expected_service;
        begin
            if (expected_service === (expected_service ^ service ^ expected_service)) begin
                $display("PASS");
                $display("  Outputs: service=%h",
                         service);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: service=%h",
                         expected_service);
                $display("  Got:      service=%h",
                         service);
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
        $dumpvars(0,ack, clk, irq, rst, service);
    end

endmodule
