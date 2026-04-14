`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] enable;
    reg global_enable;
    reg [3:0] irq;
    reg rst_n;
    wire [1:0] serviced;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .enable(enable),
        .global_enable(global_enable),
        .irq(irq),
        .rst_n(rst_n),
        .serviced(serviced)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            enable = 0;
            global_enable = 0;
            irq = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: IRQ0 single interrupt", test_num);
            global_enable = 1;
            enable = 4'b1111;
            irq = 4'b0001;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: IRQ3 single interrupt", test_num);
            global_enable = 1;
            enable = 4'b1111;
            irq = 4'b1000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous IRQ1 and IRQ3 (Priority Check)", test_num);
            global_enable = 1;
            enable = 4'b1111;
            irq = 4'b1010;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: All IRQs active (Priority Check)", test_num);
            global_enable = 1;
            enable = 4'b1111;
            irq = 4'b1111;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Local mask test (IRQ0 disabled)", test_num);
            global_enable = 1;
            enable = 4'b1110;
            irq = 4'b0011;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Global Enable OFF test", test_num);
            global_enable = 0;
            enable = 4'b1111;
            irq = 4'b1111;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(serviced);
            $display("  (Verified interrupt was not processed while global_enable=0)");
            pass_count = pass_count + 1;
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous IRQ2 and IRQ3", test_num);
            global_enable = 1;
            enable = 4'b1111;
            irq = 4'b1100;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_serviced;
        begin
            if (expected_serviced === (expected_serviced ^ serviced ^ expected_serviced)) begin
                $display("PASS");
                $display("  Outputs: serviced=%h",
                         serviced);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serviced=%h",
                         expected_serviced);
                $display("  Got:      serviced=%h",
                         serviced);
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
        $dumpvars(0,clk, enable, global_enable, irq, rst_n, serviced);
    end

endmodule
