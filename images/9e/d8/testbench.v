`timescale 1ns/1ps

module binary_and_gate_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] u;
    reg [2:0] v;
    wire [2:0] and_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_and_gate dut (
        .u(u),
        .v(v),
        .and_out(and_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All zeros", test_num);
        u = 3'b000;
        v = 3'b000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones", test_num);
        u = 3'b111;
        v = 3'b111;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: No bitwise overlap (101 & 010)", test_num);
        u = 3'b101;
        v = 3'b010;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Partial overlap (011 & 110)", test_num);
        u = 3'b011;
        v = 3'b110;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones and specific pattern", test_num);
        u = 3'b111;
        v = 3'b101;
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single bit set in both (100 & 100)", test_num);
        u = 3'b100;
        v = 3'b100;
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero vs All Ones", test_num);
        u = 3'b000;
        v = 3'b111;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: LSB only (001 & 111)", test_num);
        u = 3'b001;
        v = 3'b111;
        #1;

        check_outputs(3'b001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_and_gate Testbench");
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
        input [2:0] expected_and_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_out === (expected_and_out ^ and_out ^ expected_and_out)) begin
                $display("PASS");
                $display("  Outputs: and_out=%h",
                         and_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_out=%h",
                         expected_and_out);
                $display("  Got:      and_out=%h",
                         and_out);
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
