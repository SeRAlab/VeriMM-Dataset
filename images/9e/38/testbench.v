`timescale 1ns/1ps

module further_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg m;
    wire n;
    wire o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    further_module dut (
        .clock(clock),
        .m(m),
        .n(n),
        .o(o)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        integer i;
        begin



            m = 0;
            @(posedge clock);
            for (i = 0; i < 4; i = i + 1) begin
                if (n !== 1'b0 || o !== 1'b0) begin
                    m = 1;
                    @(posedge clock);
                    #1;
                end
            end
            m = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            m = 1;
            @(posedge clock);
            #1 m = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            m = 1;
            @(posedge clock);
            @(posedge clock);
            #1 m = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            m = 1;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #1 m = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            m = 1;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #1 m = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            m = 1;
            @(posedge clock);
            #1 m = 0;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();


            m = 1;
            @(posedge clock);
            @(posedge clock);
            #1 m = 0;
            @(posedge clock);
            #1 m = 1;
            @(posedge clock);
            #1 m = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();


            m = 1;
            repeat(5) @(posedge clock);
            #1 m = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("further_module Testbench");
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
        input expected_n;
        input expected_o;
        begin
            if (expected_n === (expected_n ^ n ^ expected_n) &&
                expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: n=%b, o=%b",
                         n, o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: n=%b, o=%b",
                         expected_n, expected_o);
                $display("  Got:      n=%b, o=%b",
                         n, o);
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
        $dumpvars(0,clock, m, n, o);
    end

endmodule
