`timescale 1ns/1ps

module enable_dff_tb;

    // Testbench signals (sequential circuit)
    reg data;
    reg enable;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    enable_dff dut (
        .data(data),
        .enable(enable),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

    begin


        if (enable === 1) @(negedge enable);
        data = 0;
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        data = 1;
        @(posedge enable);
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        data = 0;
        @(posedge enable);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        data = 1;
        @(posedge enable);
        #1;
        data = 0;
        #1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        data = 1;
        @(posedge enable);
        #1;
        @(negedge enable);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        data = 1;
        #2;
        data = 0;
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();


        data = 1;
        @(posedge enable);
        #1;


        @(negedge enable);
        #1;


        data = 0;
        @(posedge enable);
        #1;
        #1;

        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("enable_dff Testbench");
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,data, enable, out);
    end

endmodule
