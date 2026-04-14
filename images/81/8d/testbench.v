`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg r_a;
    reg r_b;
    wire r_d;
    wire r_e;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .r_a(r_a),
        .r_b(r_b),
        .r_d(r_d),
        .r_e(r_e)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            r_a = 0;
            r_b = 0;
            @(posedge clk);
            #1;


        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Setting r_e HIGH", test_num);
            r_a = 1;
            r_b = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(r_d, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Setting r_e LOW", test_num);

            r_a = 1; r_b = 1;
            @(posedge clk);
            #1;

            r_a = 0;
            r_b = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(r_d, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Setting r_d HIGH", test_num);
            r_a = 0;
            r_b = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, r_e);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Setting r_d LOW", test_num);
            r_a = 1;
            r_b = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, r_e);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Verify r_e holds value while r_d toggles", test_num);

            r_a = 1; r_b = 1;
            @(posedge clk); #1;

            r_a = 0; r_b = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Verify r_d holds value while r_e toggles", test_num);

            r_a = 0; r_b = 1;
            @(posedge clk); #1;

            r_a = 0; r_b = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Complex transition sequence", test_num);

            r_a = 1; r_b = 1; @(posedge clk); #1;

            r_a = 1; r_b = 0; @(posedge clk); #1;

            r_a = 0; r_b = 0; @(posedge clk); #1;
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_r_d;
        input expected_r_e;
        begin
            if (expected_r_d === (expected_r_d ^ r_d ^ expected_r_d) &&
                expected_r_e === (expected_r_e ^ r_e ^ expected_r_e)) begin
                $display("PASS");
                $display("  Outputs: r_d=%b, r_e=%b",
                         r_d, r_e);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_d=%b, r_e=%b",
                         expected_r_d, expected_r_e);
                $display("  Got:      r_d=%b, r_e=%b",
                         r_d, r_e);
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
        $dumpvars(0,clk, r_a, r_b, r_d, r_e);
    end

endmodule
