`timescale 1ns/1ps

module sparc_ifu_incr46_tb;

    // Testbench signals (combinational circuit)
    reg [45:0] a;
    wire [45:0] a_inc;
    wire ofl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sparc_ifu_incr46 dut (
        .a(a),
        .a_inc(a_inc),
        .ofl(ofl)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Increment Zero", test_num);
            a = 46'h0;
            #1;

            check_outputs(46'h1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Normal Increment", test_num);
            a = 46'hA_5A5A_5A5A;
            #1;

            check_outputs(46'hA_5A5A_5A5B, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary - One below MSB flip point", test_num);



            a = 46'h1FFF_FFFF_FFFE;
            #1;

            check_outputs(46'h1FFF_FFFF_FFFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow Detection (MSB 0 to 1)", test_num);


            a = 46'h1FFF_FFFF_FFFF;
            #1;

            check_outputs(46'h2000_0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Increment with MSB already 1", test_num);
            a = 46'h2000_0000_0000;
            #1;

            check_outputs(46'h2000_0000_0001, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Value Wrap Around (Carry-out but no MSB 0->1)", test_num);

            a = 46'h3FFF_FFFF_FFFF;
            #1;

            check_outputs(46'h0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random High Value", test_num);
            a = 46'h30AD_BEEF_CAFE;
            #1;

            check_outputs(46'h30AD_BEEF_CAFF, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sparc_ifu_incr46 Testbench");
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
        input [45:0] expected_a_inc;
        input expected_ofl;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_inc === (expected_a_inc ^ a_inc ^ expected_a_inc) &&
                expected_ofl === (expected_ofl ^ ofl ^ expected_ofl)) begin
                $display("PASS");
                $display("  Outputs: a_inc=%h, ofl=%b",
                         a_inc, ofl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_inc=%h, ofl=%b",
                         expected_a_inc, expected_ofl);
                $display("  Got:      a_inc=%h, ofl=%b",
                         a_inc, ofl);
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
