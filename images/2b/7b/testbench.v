`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ext_interrupt_en;
    reg ext_interrupt_req;
    reg reset;
    reg timer_interrupt_en;
    reg timer_interrupt_req;
    wire interrupt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .ext_interrupt_en(ext_interrupt_en),
        .ext_interrupt_req(ext_interrupt_req),
        .reset(reset),
        .timer_interrupt_en(timer_interrupt_en),
        .timer_interrupt_req(timer_interrupt_req),
        .interrupt(interrupt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ext_interrupt_en = 0;
            ext_interrupt_req = 0;
            timer_interrupt_en = 0;
            timer_interrupt_req = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Default state after reset (no requests)", test_num);
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: External interrupt enabled and requested", test_num);
            reset_dut();
            ext_interrupt_en = 1;
            ext_interrupt_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: External interrupt requested but disabled", test_num);
            reset_dut();
            ext_interrupt_en = 0;
            ext_interrupt_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Timer interrupt enabled and requested", test_num);
            reset_dut();
            timer_interrupt_en = 1;
            timer_interrupt_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Timer interrupt requested but disabled", test_num);
            reset_dut();
            timer_interrupt_en = 0;
            timer_interrupt_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Both interrupts enabled and requested", test_num);
            reset_dut();
            ext_interrupt_en = 1;
            ext_interrupt_req = 1;
            timer_interrupt_en = 1;
            timer_interrupt_req = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: External disabled/request, Timer enabled/no-request", test_num);
            reset_dut();
            ext_interrupt_en = 0;
            ext_interrupt_req = 1;
            timer_interrupt_en = 1;
            timer_interrupt_req = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Reset clears active interrupt", test_num);
            reset_dut();

            ext_interrupt_en = 1;
            ext_interrupt_req = 1;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            #1 #1;
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
        $dumpvars(0,clk, ext_interrupt_en, ext_interrupt_req, reset, timer_interrupt_en, timer_interrupt_req, interrupt);
    end

endmodule
