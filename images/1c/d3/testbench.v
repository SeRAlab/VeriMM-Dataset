`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg acknowledge;
    reg clk;
    reg interrupt_request;
    reg reset;
    wire interrupt_pending;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .acknowledge(acknowledge),
        .clk(clk),
        .interrupt_request(interrupt_request),
        .reset(reset),
        .interrupt_pending(interrupt_pending)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            acknowledge = 0;
            interrupt_request = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Idle", test_num);
            reset_dut();


            repeat(2) @(posedge clk);

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set Interrupt Pending", test_num);
            reset_dut();


            interrupt_request = 1;
            acknowledge = 0;
            @(posedge clk);
            interrupt_request = 0;
            @(posedge clk);

            #1;


            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear Interrupt Pending", test_num);
            reset_dut();


            interrupt_request = 1;
            @(posedge clk);
            interrupt_request = 0;


            acknowledge = 1;
            @(posedge clk);
            acknowledge = 0;
            @(posedge clk);

            #1;


            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Req and Ack", test_num);
            reset_dut();

            interrupt_request = 1;
            acknowledge = 1;
            @(posedge clk);
            interrupt_request = 0;
            acknowledge = 0;
            @(posedge clk);

            #1;


            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Persistence check", test_num);
            reset_dut();


            interrupt_request = 1;
            @(posedge clk);
            interrupt_request = 0;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Interrupts", test_num);
            reset_dut();


            interrupt_request = 1;
            @(posedge clk);
            interrupt_request = 0;
            acknowledge = 1;
            @(posedge clk);
            acknowledge = 0;
            interrupt_request = 1;
            @(posedge clk);
            interrupt_request = 0;
            @(posedge clk);

            #1;


            check_outputs(1);
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
        input expected_interrupt_pending;
        begin
            if (expected_interrupt_pending === (expected_interrupt_pending ^ interrupt_pending ^ expected_interrupt_pending)) begin
                $display("PASS");
                $display("  Outputs: interrupt_pending=%b",
                         interrupt_pending);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt_pending=%b",
                         expected_interrupt_pending);
                $display("  Got:      interrupt_pending=%b",
                         interrupt_pending);
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
        $dumpvars(0,acknowledge, clk, interrupt_request, reset, interrupt_pending);
    end

endmodule
