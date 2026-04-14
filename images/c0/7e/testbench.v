`timescale 1ns/1ps

module zsoffr_prim_tb;

    // Testbench signals (sequential circuit)
    reg ck;
    reg d;
    reg r_l;
    reg sd;
    reg se;
    wire q;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zsoffr_prim dut (
        .ck(ck),
        .d(d),
        .r_l(r_l),
        .sd(sd),
        .se(se),
        .q(q),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

        task reset_dut;

        begin
            r_l = 0;
            d = 0;
            sd = 0;
            se = 0;
            #15;
            r_l = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Asynchronous Reset Check", test_num);
            reset_dut();

            d = 1;
            se = 0;
            @(posedge ck);
            #2;

            r_l = 0;
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Normal Mode - Load High", test_num);
            reset_dut();
            d = 1;
            se = 0;
            sd = 0;
            @(posedge ck);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Normal Mode - Load Low", test_num);
            reset_dut();

            d = 1; se = 0; @(posedge ck); #2;

            d = 0;
            @(posedge ck);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Scan Mode - Load High", test_num);
            reset_dut();
            se = 1;
            sd = 1;
            d = 0;
            @(posedge ck);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Scan Mode - Load Low", test_num);
            reset_dut();

            se = 0; d = 1; @(posedge ck); #2;

            se = 1;
            sd = 0;
            d = 1;
            @(posedge ck);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Data Hold Stability", test_num);
            reset_dut();
            d = 1;
            se = 0;
            @(posedge ck);
            #2;
            d = 0;
            #5;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %03d: Sequential Toggle", test_num);
            reset_dut();
            se = 0;
            d = 1; @(posedge ck); #2;
            d = 0; @(posedge ck); #2;
            d = 1; @(posedge ck); #2;
            d = 1; @(posedge ck); #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zsoffr_prim Testbench");
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
        input expected_q;
        input expected_so;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: q=%b, so=%b",
                         q, so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, so=%b",
                         expected_q, expected_so);
                $display("  Got:      q=%b, so=%b",
                         q, so);
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
        $dumpvars(0,ck, d, r_l, sd, se, q, so);
    end

endmodule
