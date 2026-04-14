`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] force_bits;
    reg [3:0] force_values;
    reg [3:0] in;
    reg [3:0] release_bits;
    wire [3:0] bus;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .force_bits(force_bits),
        .force_values(force_values),
        .in(in),
        .release_bits(release_bits),
        .bus(bus)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Transparent Mode (No bits forced)");
            in = 4'b1010;
            force_bits = 4'b0000;
            force_values = 4'b0101;
            release_bits = 4'b0000;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Full Override (All bits forced)");
            in = 4'b1010;
            force_bits = 4'b1111;
            force_values = 4'b0101;
            release_bits = 4'b0000;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Partial Force (Mix of forced and original bits)");
            in = 4'b1111;
            force_bits = 4'b1100;
            force_values = 4'b0011;
            release_bits = 4'b0000;

            #1;


            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Release Priority (Force and Release active for same bits)");
            in = 4'b1010;
            force_bits = 4'b1111;
            force_values = 4'b0000;
            release_bits = 4'b1111;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Selective Release (Some bits forced, some released)");
            in = 4'b0000;
            force_bits = 4'b1011;
            force_values = 4'b1111;
            release_bits = 4'b0001;




            #1;





            check_outputs(4'b1010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Force values to 0");
            in = 4'b1111;
            force_bits = 4'b0110;
            force_values = 4'b0000;
            release_bits = 4'b0000;




            #1;





            check_outputs(4'b1001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Release bit not currently forced");
            in = 4'b1011;
            force_bits = 4'b1000;
            force_values = 4'b0111;
            release_bits = 4'b0100;




            #1;





            check_outputs(4'b0011);
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
        input [3:0] expected_bus;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bus === (expected_bus ^ bus ^ expected_bus)) begin
                $display("PASS");
                $display("  Outputs: bus=%h",
                         bus);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bus=%h",
                         expected_bus);
                $display("  Got:      bus=%h",
                         bus);
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
