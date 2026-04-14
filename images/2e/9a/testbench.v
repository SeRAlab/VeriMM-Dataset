`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg int_req;
    reg rst;
    wire int_active;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .clk(clk),
        .enable(enable),
        .int_req(int_req),
        .rst(rst),
        .int_active(int_active)
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
            int_req = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set Interrupt (Enable=1, Req=1)", test_num);
            reset_dut();
            enable = 1;
            int_req = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Latch Persistence", test_num);
            reset_dut();
            enable = 1;
            int_req = 1;
            @(posedge clk);
            #1 int_req = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clear Interrupt (Enable=0)", test_num);
            reset_dut();
            enable = 1;
            int_req = 1;
            @(posedge clk);
            #1 enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Latch when Disabled", test_num);
            reset_dut();
            enable = 0;
            int_req = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-enable without new request", test_num);
            reset_dut();

            enable = 1; int_req = 1; @(posedge clk);
            #1 enable = 0; @(posedge clk);

            #1 enable = 1; int_req = 0;
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
        input expected_int_active;
        begin
            if (expected_int_active === (expected_int_active ^ int_active ^ expected_int_active)) begin
                $display("PASS");
                $display("  Outputs: int_active=%b",
                         int_active);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_active=%b",
                         expected_int_active);
                $display("  Got:      int_active=%b",
                         int_active);
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
        $dumpvars(0,clk, enable, int_req, rst, int_active);
    end

endmodule
