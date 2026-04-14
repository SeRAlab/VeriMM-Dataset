`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd_in;
    wire [7:0] ascii_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd_in(bcd_in),
        .ascii_out(ascii_out)
    );
    task testcase001;

    begin
        bcd_in = 4'd0;
        #1;

        check_outputs(8'h30);
    end
        endtask

    task testcase002;

    begin
        bcd_in = 4'd1;
        #1;

        check_outputs(8'h31);
    end
        endtask

    task testcase003;

    begin
        bcd_in = 4'd2;
        #1;

        check_outputs(8'h32);
    end
        endtask

    task testcase004;

    begin
        bcd_in = 4'd5;
        #1;

        check_outputs(8'h35);
    end
        endtask

    task testcase005;

    begin
        bcd_in = 4'd8;
        #1;

        check_outputs(8'h38);
    end
        endtask

    task testcase006;

    begin
        bcd_in = 4'd9;
        #1;

        check_outputs(8'h39);
    end
        endtask

    task testcase007;

    begin
        bcd_in = 4'd10;
        #1;

        check_outputs(8'h2B);
    end
        endtask

    task testcase008;

    begin
        bcd_in = 4'd11;
        #1;

        check_outputs(8'h2D);
    end
        endtask

    task testcase009;

    begin
        bcd_in = 4'd12;
        #1;

        check_outputs(8'h3D);
    end
        endtask

    task testcase010;

    begin
        bcd_in = 4'd13;
        #1;

        check_outputs(8'h3D);
    end
        endtask

    task testcase011;

    begin
        bcd_in = 4'd14;
        #1;

        check_outputs(8'h3E);
    end
        endtask

    task testcase012;

    begin
        bcd_in = 4'd15;
        #1;

        check_outputs(8'h3F);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_ascii_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ascii_out === (expected_ascii_out ^ ascii_out ^ expected_ascii_out)) begin
                $display("PASS");
                $display("  Outputs: ascii_out=%h",
                         ascii_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ascii_out=%h",
                         expected_ascii_out);
                $display("  Got:      ascii_out=%h",
                         ascii_out);
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
