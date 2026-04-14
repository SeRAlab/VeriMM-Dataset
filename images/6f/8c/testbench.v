`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] in1_im;
    reg [17:0] in1_re;
    reg [17:0] in2_im;
    reg [17:0] in2_re;
    wire [35:0] im;
    wire [35:0] re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1_im(in1_im),
        .in1_re(in1_re),
        .in2_im(in2_im),
        .in2_re(in2_re),
        .im(im),
        .re(re)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            in1_re = 18'sd0;
            in1_im = 18'sd0;
            in2_re = 18'sd0;
            in2_im = 18'sd0;
            #1;

            check_outputs(36'sd0, 36'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple positive integers", test_num);



            in1_re = 18'sd10;
            in1_im = 18'sd20;
            in2_re = 18'sd30;
            in2_im = 18'sd40;
            #1;

            check_outputs(36'sd1000, 36'sd-500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed signs", test_num);



            in1_re = -18'sd100;
            in1_im = 18'sd50;
            in2_re = 18'sd20;
            in2_im = -18'sd10;
            #1;

            check_outputs(36'sd2000, 36'sd-1500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large positive values (Real focus)", test_num);



            in1_re = 18'sd131071;
            in1_im = 18'sd0;
            in2_re = 18'sd131071;
            in2_im = 18'sd0;
            #1;

            check_outputs(36'sd0, 36'sd17179607041);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large negative values (Imaginary focus)", test_num);



            in1_re = 18'sd0;
            in1_im = -18'sd131072;
            in2_re = 18'sd0;
            in2_im = -18'sd131072;
            #1;

            check_outputs(36'sd0, 36'sd-17179869184);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex conjugate pair", test_num);



            in1_re = 18'sd500;
            in1_im = 18'sd500;
            in2_re = 18'sd500;
            in2_im = -18'sd500;
            #1;

            check_outputs(36'sd0, 36'sd500000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fixed-point 1.0 identity check", test_num);





            in1_re = 18'sd65536;
            in1_im = 18'sd0;
            in2_re = 18'sd32768;
            in2_im = 18'sd16384;
            #1;

            check_outputs(36'sd1073741824, 36'sd2147483648);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplying by imaginary unit 'i'", test_num);





            in1_re = 18'sd100;
            in1_im = 18'sd200;
            in2_re = 18'sd0;
            in2_im = 18'sd65536;
            #1;

            check_outputs(36'sd6553600, 36'sd-13107200);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small negative integers", test_num);



            in1_re = -18'sd1;
            in1_im = -18'sd1;
            in2_re = -18'sd1;
            in2_im = -18'sd1;
            #1;

            check_outputs(36'sd2, 36'sd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max range cross multiplication", test_num);



            in1_re = 18'sd131071;
            in1_im = -18'sd131072;
            in2_re = 18'sd1;
            in2_im = 18'sd1;
            #1;

            check_outputs(36'sd-1, 36'sd262143);
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
        input [35:0] expected_im;
        input [35:0] expected_re;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_im === (expected_im ^ im ^ expected_im) &&
                expected_re === (expected_re ^ re ^ expected_re)) begin
                $display("PASS");
                $display("  Outputs: im=%h, re=%h",
                         im, re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: im=%h, re=%h",
                         expected_im, expected_re);
                $display("  Got:      im=%h, re=%h",
                         im, re);
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
