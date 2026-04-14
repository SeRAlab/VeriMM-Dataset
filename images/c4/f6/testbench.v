`timescale 1ns/1ps

module clock_gating_cell_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg en;
    wire gclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gating_cell dut (
        .clk(clk),
        .en(en),
        .gclk(gclk)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Clock Gating Enabled (en=0), Clock Low (clk=0)", test_num);
        en = 0;
        clk = 0;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Clock Gating Enabled (en=0), Clock High (clk=1)", test_num);
        en = 0;
        clk = 1;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Clock Gating Disabled (en=1), Clock Low (clk=0)", test_num);
        en = 1;
        clk = 0;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Clock Gating Disabled (en=1), Clock High (clk=1)", test_num);
        en = 1;
        clk = 1;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Transition en 0 -> 1 while clock is high", test_num);
        en = 0;
        clk = 1;
        #10;
        en = 1;
        #10;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Transition en 1 -> 0 while clock is high", test_num);
        en = 1;
        clk = 1;
        #10;
        en = 0;
        #10;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Toggling clock while enable is high", test_num);
        en = 1;
        clk = 0; #5;
        clk = 1; #5;
        clk = 0; #5;
        clk = 1; #5;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Toggling clock while enable is low", test_num);
        en = 0;
        clk = 0; #5;
        clk = 1; #5;
        clk = 0; #5;
        clk = 1; #5;
        #1;

        check_outputs(0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_gating_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_gclk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gclk === (expected_gclk ^ gclk ^ expected_gclk)) begin
                $display("PASS");
                $display("  Outputs: gclk=%b",
                         gclk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gclk=%b",
                         expected_gclk);
                $display("  Got:      gclk=%b",
                         gclk);
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
