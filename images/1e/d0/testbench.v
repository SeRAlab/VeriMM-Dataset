`timescale 1ns/1ps

module flash_memory_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg RE;
    reg WE;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Writing 1 and Reading back", test_num);

        D = 0; WE = 0; RE = 0; #10;

        D = 1; WE = 1; RE = 0; #10;

        WE = 0; RE = 1; #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Writing 0 and Reading back", test_num);

        D = 1; WE = 0; RE = 0; #10;

        D = 0; WE = 1; RE = 0; #10;

        WE = 0; RE = 1; #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verify retention when WE=0, RE=0", test_num);

        D = 1; WE = 1; RE = 0; #10;

        WE = 0; RE = 1; #10;

        WE = 0; RE = 0; D = 0; #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Overwriting 1 with 0", test_num);

        D = 1; WE = 1; RE = 0; #10;

        D = 0; WE = 1; RE = 0; #10;

        WE = 0; RE = 1; #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verify WE=0 prevents data from changing", test_num);

        D = 1; WE = 1; RE = 0; #10;

        D = 0; WE = 0; RE = 0; #10;

        WE = 0; RE = 1; #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Simultaneous Write and Read", test_num);

        D = 1; WE = 1; RE = 1; #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory Testbench");
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
        input expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
