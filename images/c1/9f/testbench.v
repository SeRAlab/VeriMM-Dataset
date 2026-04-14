`timescale 1ns/1ps

module dff_s_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg se;
    reg si;
    wire q;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dff_s dut (
        .clk(clk),
        .din(din),
        .se(se),
        .si(si),
        .q(q),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            din = 0;
            se = 0;
            si = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Mode - Store '1'", test_num);

            se = 0;
            din = 1;
            si = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Mode - Store '0'", test_num);


            se = 0; din = 1; @(posedge clk); #1;


            din = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Scan Mode - Shift '1'", test_num);

            se = 1;
            si = 1;
            din = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Scan Mode - Shift '0'", test_num);


            se = 1; si = 1; @(posedge clk); #1;


            si = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Mode Switch Priority", test_num);


            se = 0; din = 1; @(posedge clk); #1;


            se = 1; si = 0;
            #2;


            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Scan Enable Override din", test_num);

            se = 1;
            si = 1;
            din = 0;

            @(posedge clk);
            #2;

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
        $display("dff_s Testbench");
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
        $dumpvars(0,clk, din, se, si, q, so);
    end

endmodule
