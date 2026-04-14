`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg _1;
    reg _2;
    reg _3;
    reg _6;
    reg _7;
    reg clock;
    wire _22;
    wire _23;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        ._1(_1),
        ._2(_2),
        ._3(_3),
        ._6(_6),
        ._7(_7),
        .clock(clock),
        ._22(_22),
        ._23(_23)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            _1 = 0;
            _2 = 0;
            _3 = 0;
            _6 = 0;
            _7 = 0;
            repeat(2) @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            _1 = 0; _2 = 0; _3 = 0; _6 = 0; _7 = 0;
            @(posedge clock);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            _1 = 1; _2 = 1; _3 = 1; _6 = 1; _7 = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            _1 = 1; _2 = 0; _3 = 0; _6 = 0; _7 = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            _1 = 0; _2 = 1; _3 = 0; _6 = 0; _7 = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            _1 = 0; _2 = 0; _3 = 1; _6 = 0; _7 = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            _1 = 1; _2 = 0; _3 = 1; _6 = 0; _7 = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            _1 = 0; _2 = 1; _3 = 0; _6 = 1; _7 = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            _1 = 1; _2 = 1; _3 = 0; _6 = 0; _7 = 1;
            @(posedge clock);
            #2;
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
        $display("top_module Testbench");
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
        input expected__22;
        input expected__23;
        begin
            if (expected__22 === (expected__22 ^ _22 ^ expected__22) &&
                expected__23 === (expected__23 ^ _23 ^ expected__23)) begin
                $display("PASS");
                $display("  Outputs: _22=%b, _23=%b",
                         _22, _23);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: _22=%b, _23=%b",
                         expected__22, expected__23);
                $display("  Got:      _22=%b, _23=%b",
                         _22, _23);
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
        $dumpvars(0,_1, _2, _3, _6, _7, clock, _22, _23);
    end

endmodule
