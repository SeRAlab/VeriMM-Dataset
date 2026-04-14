`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c;
    reg r;
    wire cout;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .r(r),
        .cout(cout),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        c = 0;
        forever #5 c = ~c;
    end

        task reset_dut;

        begin
            r = 1;
            #10;
            r = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment to 1", test_num);
            reset_dut();
            @(posedge c);
            #1;
            #1;

            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increment to 15", test_num);
            reset_dut();
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge c);
            end
            #1;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rollover event check", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge c);
            end
            #1;

            #1;


            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Post-rollover state", test_num);
            reset_dut();

            for (i = 0; i < 17; i = i + 1) begin
                @(posedge c);
            end
            #1;

            #1;


            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asynchronous reset mid-count", test_num);
            reset_dut();

            for (i = 0; i < 5; i = i + 1) begin
                @(posedge c);
            end
            #2;
            r = 1;
            #1;

            #1;


            check_outputs(1'b0, 4'h0);
            r = 0;
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two full cycles (32 increments)", test_num);
            reset_dut();

            for (i = 0; i < 32; i = i + 1) begin
                @(posedge c);
            end
            #1;

            #1;


            check_outputs(1'b1, 4'h0);
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
        input expected_cout;
        input [3:0] expected_q;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, q=%h",
                         cout, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, q=%h",
                         expected_cout, expected_q);
                $display("  Got:      cout=%b, q=%h",
                         cout, q);
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
        $dumpvars(0,c, r, cout, q);
    end

endmodule
