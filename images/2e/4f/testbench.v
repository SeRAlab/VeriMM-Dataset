`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg IRQ0;
    reg IRQ1;
    reg IRQ2;
    reg ack;
    reg clk;
    reg reset;
    wire INT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .IRQ0(IRQ0),
        .IRQ1(IRQ1),
        .IRQ2(IRQ2),
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .INT(INT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            IRQ0 = 0;
            IRQ1 = 0;
            IRQ2 = 0;
            ack = 0;
            reset = 1;
            #20;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: IRQ0 high priority trigger", test_num);
            reset_dut();
            IRQ0 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: IRQ1 medium priority trigger", test_num);
            reset_dut();
            IRQ1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: IRQ2 low priority trigger", test_num);
            reset_dut();
            IRQ2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous IRQ0 and IRQ2", test_num);
            reset_dut();
            IRQ0 = 1;
            IRQ2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: No IRQ active", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Acknowledge clearing INT", test_num);
            reset_dut();
            IRQ0 = 1;
            @(posedge clk);
            #1;
            ack = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset during IRQ", test_num);
            reset_dut();
            IRQ0 = 1;
            IRQ1 = 1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: INT duration check", test_num);
            reset_dut();
            IRQ0 = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
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
        input expected_INT;
        begin
            if (expected_INT === (expected_INT ^ INT ^ expected_INT)) begin
                $display("PASS");
                $display("  Outputs: INT=%b",
                         INT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: INT=%b",
                         expected_INT);
                $display("  Got:      INT=%b",
                         INT);
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
        $dumpvars(0,IRQ0, IRQ1, IRQ2, ack, clk, reset, INT);
    end

endmodule
