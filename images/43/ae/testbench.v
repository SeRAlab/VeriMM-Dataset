`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ADDR;
    wire [31:0] DATA_IM;
    wire [31:0] DATA_RE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .DATA_IM(DATA_IM),
        .DATA_RE(DATA_RE)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase001: Address 0x0 (Boundary Low)");
            ADDR = 4'h0;

            #1;


            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase002: Address 0xF (Boundary High)");
            ADDR = 4'hF;

            #1;


            check_outputs(32'h0000000F, 32'h0000000F);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning testcase003: Sequential Sweep (Addresses 1-7)");
            for (i = 1; i <= 7; i = i + 1) begin
                ADDR = i[3:0];


                #1;



                check_outputs(32'h00000000 + i, 32'h00000000 + i);
            end
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning testcase004: Sequential Sweep (Addresses 8-14)");
            for (i = 8; i <= 14; i = i + 1) begin
                ADDR = i[3:0];

                #1;


                check_outputs(32'h00000000 + i, 32'h00000000 + i);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning testcase005: Bit-walking Pattern (1, 2, 4, 8)");

            ADDR = 4'b0001; #1;
 check_outputs(32'h00000001, 32'h00000001);
            ADDR = 4'b0010; #1;
 check_outputs(32'h00000002, 32'h00000002);
            ADDR = 4'b0100; #1;
 check_outputs(32'h00000004, 32'h00000004);
            ADDR = 4'b1000; #1;
 check_outputs(32'h00000008, 32'h00000008);
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
        input [31:0] expected_DATA_IM;
        input [31:0] expected_DATA_RE;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DATA_IM === (expected_DATA_IM ^ DATA_IM ^ expected_DATA_IM) &&
                expected_DATA_RE === (expected_DATA_RE ^ DATA_RE ^ expected_DATA_RE)) begin
                $display("PASS");
                $display("  Outputs: DATA_IM=%h, DATA_RE=%h",
                         DATA_IM, DATA_RE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_IM=%h, DATA_RE=%h",
                         expected_DATA_IM, expected_DATA_RE);
                $display("  Got:      DATA_IM=%h, DATA_RE=%h",
                         DATA_IM, DATA_RE);
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
