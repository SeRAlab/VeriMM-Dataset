`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg IRQ;
    reg ack;
    reg clk;
    reg reset;
    wire interrupt_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .IRQ(IRQ),
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .interrupt_flag(interrupt_flag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            IRQ = 0;
            ack = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset state", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: IRQ sets flag", test_num);
            reset_dut();
            IRQ = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
            IRQ = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Ack clears flag", test_num);
            reset_dut();

            IRQ = 1;
            @(posedge clk);
            #1 IRQ = 0;

            ack = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
            ack = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Flag persistence", test_num);
            reset_dut();
            IRQ = 1;
            @(posedge clk);
            #1 IRQ = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset overrides IRQ", test_num);
            reset_dut();
            reset = 1;
            IRQ = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
            reset = 0;
            IRQ = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Ack vs Active IRQ", test_num);
            reset_dut();
            IRQ = 1;
            @(posedge clk);
            #1 ack = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(1'b0);
            ack = 0;
            IRQ = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Multiple IRQ pulses", test_num);
            reset_dut();
            IRQ = 1; @(posedge clk); #1 IRQ = 0;
            @(posedge clk);
            IRQ = 1; @(posedge clk); #1 IRQ = 0;
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
        input expected_interrupt_flag;
        begin
            if (expected_interrupt_flag === (expected_interrupt_flag ^ interrupt_flag ^ expected_interrupt_flag)) begin
                $display("PASS");
                $display("  Outputs: interrupt_flag=%b",
                         interrupt_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt_flag=%b",
                         expected_interrupt_flag);
                $display("  Got:      interrupt_flag=%b",
                         interrupt_flag);
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
        $dumpvars(0,IRQ, ack, clk, reset, interrupt_flag);
    end

endmodule
