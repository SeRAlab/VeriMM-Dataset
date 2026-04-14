`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (combinational circuit)
    reg d;
    reg re;
    reg we;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .d(d),
        .re(re),
        .we(we),
        .q(q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Write 0 and Read 0", test_num);

        d = 0; we = 1; re = 0; #10;
        we = 0; #10;


        re = 1;
        #10;
        #1;

        check_outputs(1'b0);
        re = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Write 1 and Read 1", test_num);

        d = 0; we = 1; re = 0; #10;


        d = 1; we = 1; #10;
        we = 0; #10;


        re = 1;
        #10;
        #1;

        check_outputs(1'b1);
        re = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Write Enable Protection Check", test_num);

        d = 1; we = 1; re = 0; #10;
        we = 0; #10;


        d = 0; we = 0; #10;


        re = 1;
        #10;
        #1;

        check_outputs(1'b1);
        re = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Overwrite Operation Check", test_num);

        d = 1; we = 1; re = 0; #10;
        we = 0; #10;


        d = 0; we = 1; #10;
        we = 0; #10;


        re = 1;
        #10;
        #1;

        check_outputs(1'b0);
        re = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Read Enable High-Z/Gating Check", test_num);

        d = 1; we = 1; re = 0; #10;
        we = 0; #10;


        re = 0;
        #10;

        #1;


        check_outputs(1'bz);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
                         q);
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
