`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] doutb;
    wire [2:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .doutb(doutb),
        .mux_out(mux_out)
    );
    task testcase001;

    begin
        test_num = 1;
        doutb = 9'b101_110_000;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        doutb = 9'b101_110_001;
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        doutb = 9'b101_110_010;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        doutb = 9'b111_111_011;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        doutb = 9'b101_010_100;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        doutb = 9'b111_111_111;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        doutb = 9'b000_111_000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        doutb = 9'b000_111_001;
        #1;

        check_outputs(3'b111);
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
        input [2:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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
