`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg acknowledge;
    reg clk;
    reg enable;
    reg request;
    reg reset;
    wire interrupt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .acknowledge(acknowledge),
        .clk(clk),
        .enable(enable),
        .request(request),
        .reset(reset),
        .interrupt(interrupt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            acknowledge = 0;
            enable = 0;
            request = 0;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Assert interrupt with enable and request high", test_num);
            enable = 1;
            request = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Ensure no interrupt when enable is low despite request", test_num);
            enable = 0;
            request = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Check that interrupt stays high after request drops", test_num);

            enable = 1;
            request = 1;
            @(posedge clk);

            #1 request = 0;
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Check that acknowledge clears the interrupt", test_num);

            enable = 1;
            request = 1;
            @(posedge clk);

            #1 acknowledge = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Interrupt triggers only when enable goes high after request is already high", test_num);
            request = 1;
            enable = 0;
            @(posedge clk);
            #1 enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Check behavior when ack and request are high simultaneously", test_num);

            enable = 1;
            request = 1;
            @(posedge clk);

            #1 acknowledge = 1;
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
        input expected_interrupt;
        begin
            if (expected_interrupt === (expected_interrupt ^ interrupt ^ expected_interrupt)) begin
                $display("PASS");
                $display("  Outputs: interrupt=%b",
                         interrupt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt=%b",
                         expected_interrupt);
                $display("  Got:      interrupt=%b",
                         interrupt);
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
        $dumpvars(0,acknowledge, clk, enable, request, reset, interrupt);
    end

endmodule
