`timescale 1ns/1ps

module new_module_5_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg f;
    wire g;
    wire h;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module_5 dut (
        .clock(clock),
        .f(f),
        .g(g),
        .h(h)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        f = 0;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase %0d: First edge with f=1 -> Expected g=1, h=x", test_num);
        f = 1;
        @(posedge clock);
        #5;
        #1;

        check_outputs(1, 1'bx);
        f = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase %0d: Second edge with f=1 -> Expected g=1, h=1", test_num);
        f = 1;
        @(posedge clock);
        #5;
        #1;

        check_outputs(1, 1);
        f = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase %0d: Third edge with f=1 -> Expected g=0, h=1", test_num);
        f = 1;
        @(posedge clock);
        #5;
        #1;

        check_outputs(0, 1);
        f = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase %0d: Fourth edge with f=1 -> Expected g=1, h=0", test_num);
        f = 1;
        @(posedge clock);
        #5;
        #1;

        check_outputs(1, 0);
        f = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase %0d: Fifth edge with f=1 -> Expected g=0, h=1", test_num);
        f = 1;
        @(posedge clock);
        #5;
        #1;

        check_outputs(0, 1);
        f = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Testcase %0d: Edge with f=0 -> Expected hold state (g=0, h=1)", test_num);
        f = 0;
        @(posedge clock);
        #5;
        #1;

        check_outputs(0, 1);
        f = 0;
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        $display("Testcase %0d: Resume toggle with f=1 -> Expected g=1, h=0", test_num);
        f = 1;
        @(posedge clock);
        #5;
        #1;

        check_outputs(1, 0);
        f = 0;
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        $display("Testcase %0d: Continue toggle with f=1 -> Expected g=0, h=1", test_num);
        f = 1;
        @(posedge clock);
        #5;
        #1;

        check_outputs(0, 1);
        f = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("new_module_5 Testbench");
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
        input expected_g;
        input expected_h;
        begin
            if (expected_g === (expected_g ^ g ^ expected_g) &&
                expected_h === (expected_h ^ h ^ expected_h)) begin
                $display("PASS");
                $display("  Outputs: g=%b, h=%b",
                         g, h);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%b, h=%b",
                         expected_g, expected_h);
                $display("  Got:      g=%b, h=%b",
                         g, h);
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
        $dumpvars(0,clock, f, g, h);
    end

endmodule
