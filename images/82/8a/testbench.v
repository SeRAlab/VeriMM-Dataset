`timescale 1ns/1ps

module sequential_reset_module_with_rst_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg rst;
    wire h;
    wire k;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sequential_reset_module_with_rst dut (
        .clock(clock),
        .rst(rst),
        .h(h),
        .k(k)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            rst = 0;
            #10;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            rst = 1;
            @(posedge clock);
            #2;
            $display("Testcase %0d: After 1 clock edge", test_num);
            #1;

            check_outputs(1'b1, 1'bx);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            rst = 1;
            repeat(2) @(posedge clock);
            #2;
            $display("Testcase %0d: After 2 clock edges", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            rst = 1;
            repeat(3) @(posedge clock);
            #2;
            $display("Testcase %0d: After 3 clock edges", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            rst = 1;
            repeat(4) @(posedge clock);
            #2;
            $display("Testcase %0d: After 4 clock edges", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            rst = 1;
            repeat(5) @(posedge clock);
            #2;
            $display("Testcase %0d: After 5 clock edges", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sequential_reset_module_with_rst Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_h;
        input expected_k;
        begin
            if (expected_h === (expected_h ^ h ^ expected_h) &&
                expected_k === (expected_k ^ k ^ expected_k)) begin
                $display("PASS");
                $display("  Outputs: h=%b, k=%b",
                         h, k);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%b, k=%b",
                         expected_h, expected_k);
                $display("  Got:      h=%b, k=%b",
                         h, k);
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
        $dumpvars(0,clock, rst, h, k);
    end

endmodule
