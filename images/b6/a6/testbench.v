`timescale 1ns/1ps

module mux_logic_tb;

    // Testbench signals (combinational circuit)
    reg i;
    reg j;
    wire [3:0] mux_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_logic dut (
        .i(i),
        .j(j),
        .mux_in(mux_in)
    );
    task testcase001;

        begin
            $display("Test Case 001: i=0, j=0");
            i = 1'b0;
            j = 1'b0;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: i=0, j=1");
            i = 1'b0;
            j = 1'b1;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: i=1, j=0");
            i = 1'b1;
            j = 1'b0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: i=1, j=1");
            i = 1'b1;
            j = 1'b1;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_logic Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_mux_in;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_in === (expected_mux_in ^ mux_in ^ expected_mux_in)) begin
                $display("PASS");
                $display("  Outputs: mux_in=%h",
                         mux_in);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_in=%h",
                         expected_mux_in);
                $display("  Got:      mux_in=%h",
                         mux_in);
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
