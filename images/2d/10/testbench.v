`timescale 1ns/1ps

module logistic_regression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    wire [7:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logistic_regression dut (
        .x1(x1),
        .x2(x2),
        .p(p)
    );
    task testcase001;

    begin
        $display("\nRunning Testcase 001: Minimum Inputs");
        x1 = 8'h00;
        x2 = 8'h00;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning Testcase 002: Maximum Inputs");
        x1 = 8'hFF;
        x2 = 8'hFF;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning Testcase 003: Mid-range Inputs");
        x1 = 8'h80;
        x2 = 8'h80;

        #1;


        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning Testcase 004: Asymmetric Inputs (High/Low)");
        x1 = 8'hF0;
        x2 = 8'h0F;
        #1;

        check_outputs(8'hA0);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning Testcase 005: Asymmetric Inputs (Low/High)");
        x1 = 8'h0A;
        x2 = 8'hE0;
        #1;

        check_outputs(8'h90);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning Testcase 006: Small positive Inputs");
        x1 = 8'h10;
        x2 = 8'h10;
        #1;

        check_outputs(8'h15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("logistic_regression Testbench");
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
        input [7:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
