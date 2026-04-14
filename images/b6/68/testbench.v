`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg const_effective;
    reg [197:0] from_const;
    reg [197:0] from_ram;
    wire [197:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .const_effective(const_effective),
        .from_const(from_const),
        .from_ram(from_ram),
        .out(out)
    );
    task testcase001;

    begin
        $display("Test Case 001: Select from_ram with all bits set to 1");
        test_num = 1;
        const_effective = 1'b0;
        from_ram = {198{1'b1}};
        from_const = {198{1'b0}};
        #1;

        check_outputs({198{1'b1}});
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Select from_const with all bits set to 1");
        test_num = 2;
        const_effective = 1'b1;
        from_ram = {198{1'b0}};
        from_const = {198{1'b1}};
        #1;

        check_outputs({198{1'b1}});
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Select from_ram with alternating bit pattern (0xAAAA...)");
        test_num = 3;
        const_effective = 1'b0;
        from_ram = {99{2'b10}};
        from_const = {99{2'b01}};
        #1;

        check_outputs({99{2'b10}});
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Select from_const with alternating bit pattern (0x5555...)");
        test_num = 4;
        const_effective = 1'b1;
        from_ram = {99{2'b10}};
        from_const = {99{2'b01}};
        #1;

        check_outputs({99{2'b01}});
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Boundary test - all bits set to 0 on both inputs");
        test_num = 5;
        const_effective = 1'b0;
        from_ram = {198{1'b0}};
        from_const = {198{1'b0}};
        #1;

        check_outputs({198{1'b0}});
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: High impedance/unassigned bit check on RAM side");
        test_num = 6;
        const_effective = 1'b0;
        from_ram = 198'h123456789ABCDEF0123456789ABCDEF0123456789ABCDE;
        from_const = 198'h0;
        #1;

        check_outputs(198'h123456789ABCDEF0123456789ABCDEF0123456789ABCDE);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: High impedance/unassigned bit check on Constant side");
        test_num = 7;
        const_effective = 1'b1;
        from_ram = 198'h0;
        from_const = 198'h3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(198'h3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
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
        input [197:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
