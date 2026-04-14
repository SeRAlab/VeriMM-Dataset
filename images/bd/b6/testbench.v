`timescale 1ns/1ps

module my_other_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg k;
    wire j;
    wire l;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    my_other_module dut (
        .clock(clock),
        .k(k),
        .j(j),
        .l(l)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            k = 0;

            @(negedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Clock High, k=0", test_num);
            reset_dut();
            k = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Clock Low, k=0", test_num);
            reset_dut();
            k = 0;
            @(negedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Clock High, k=1", test_num);
            reset_dut();
            k = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Clock Low, k=1", test_num);
            reset_dut();
            k = 1;
            @(negedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: k toggles while clock is High", test_num);
            reset_dut();
            @(posedge clock);
            #1;
            k = 1; #1;
            k = 0; #1;
            k = 1; #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: k toggles while clock is Low", test_num);
            reset_dut();
            @(negedge clock);
            #1;
            k = 1; #1;
            k = 0; #1;
            k = 1; #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("testcase%03d: Full sequence verification", test_num);
            reset_dut();


            k = 0; @(posedge clock); #2;


            k = 1; @(posedge clock); #2;


            k = 0; @(posedge clock); #2;


            k = 1; @(posedge clock); #2;

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
        $display("my_other_module Testbench");
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
        input expected_j;
        input expected_l;
        begin
            if (expected_j === (expected_j ^ j ^ expected_j) &&
                expected_l === (expected_l ^ l ^ expected_l)) begin
                $display("PASS");
                $display("  Outputs: j=%b, l=%b",
                         j, l);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: j=%b, l=%b",
                         expected_j, expected_l);
                $display("  Got:      j=%b, l=%b",
                         j, l);
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
        $dumpvars(0,clock, k, j, l);
    end

endmodule
