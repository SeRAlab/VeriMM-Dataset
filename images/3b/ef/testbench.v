`timescale 1ns/1ps

module ShiftRows_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] state_in;
    wire [127:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ShiftRows dut (
        .state_in(state_in),
        .state_out(state_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All Zeros Input", test_num);
        state_in = 128'h0;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: All Ones Input", test_num);
        state_in = {16{8'hFF}};
        #1;

        check_outputs({16{8'hFF}});
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Sequential Byte Pattern", test_num);
        state_in = 128'h000102030405060708090a0b0c0d0e0f;
        #1;

        check_outputs(128'h00050a0f04090e03080d02070c01060b);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Repeating Identical Columns", test_num);
        state_in = 128'hAABBCCDDAABBCCDDAABBCCDDAABBCCDD;
        #1;

        check_outputs(128'hAABBCCDDAABBCCDDAABBCCDDAABBCCDD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Standard AES Example Pattern", test_num);

        state_in = 128'hd4e5f8b4ffe94127da02eb8ed9c663a1;

        #1;


        check_outputs(128'hd4e9eba1ff0263b4dac6f827d9e5418e);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ShiftRows Testbench");
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
        input [127:0] expected_state_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: state_out=%h",
                         state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_out=%h",
                         expected_state_out);
                $display("  Got:      state_out=%h",
                         state_out);
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
