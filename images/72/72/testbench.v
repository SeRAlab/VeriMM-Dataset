`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] address;
    wire [31:0] Instructions;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .Instructions(Instructions)
    );
    task testcase001;

    begin
        test_num = 1;
        address = 8'd0;

        #1;


        check_outputs(32'h3c011001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        address = 8'd1;

        #1;


        check_outputs(32'h34215000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        address = 8'd2;

        #1;


        check_outputs(32'h8c220000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        address = 8'd3;

        #1;


        check_outputs(32'h8c230004);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        address = 8'd4;

        #1;


        check_outputs(32'h00432020);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        address = 8'd5;

        #1;


        check_outputs(32'hac240008);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        address = 8'd6;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        address = 8'd255;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_Instructions;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Instructions === (expected_Instructions ^ Instructions ^ expected_Instructions)) begin
                $display("PASS");
                $display("  Outputs: Instructions=%h",
                         Instructions);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Instructions=%h",
                         expected_Instructions);
                $display("  Got:      Instructions=%h",
                         Instructions);
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
