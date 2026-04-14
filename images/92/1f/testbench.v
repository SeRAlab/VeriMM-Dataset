`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] rnd;
    reg [7:0] v;
    wire [3:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rnd(rnd),
        .v(v),
        .d(d)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        v = 8'h00; rnd = 8'h00;
        #10;
        $display("Testcase %0d: Zero inputs", test_num);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        v = 8'hF0; rnd = 8'h00;
        #10;
        $display("Testcase %0d: Base value, no noise", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        v = 8'h12; rnd = 8'h0D;
        #10;
        $display("Testcase %0d: Low value, sum just below threshold", test_num);
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        v = 8'h12; rnd = 8'h0E;
        #10;
        $display("Testcase %0d: Low value, sum hits threshold", test_num);
        #1;

        check_outputs(4'h2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        v = 8'h80; rnd = 8'h7F;
        #10;
        $display("Testcase %0d: Mid value, sum at 255", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        v = 8'h80; rnd = 8'h80;
        #10;
        $display("Testcase %0d: Mid value, overflow saturation", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        v = 8'hFF; rnd = 8'hFF;
        #10;
        $display("Testcase %0d: Max values saturation", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        v = 8'h40; rnd = 8'h40;
        #10;
        $display("Testcase %0d: Mid-range addition", test_num);
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        v = 8'h00; rnd = 8'hFF;
        #10;
        $display("Testcase %0d: Zero base, max noise", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        v = 8'h23; rnd = 8'h11;
        #10;
        $display("Testcase %0d: Arbitrary mid-point", test_num);
        #1;

        check_outputs(4'h3);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: d=%h",
                         d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h",
                         expected_d);
                $display("  Got:      d=%h",
                         d);
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

endmodule
