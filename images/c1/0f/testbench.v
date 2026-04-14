`timescale 1ns/1ps

module compressor42_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg cin;
    wire S;
    wire carry;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    compressor42 dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .cin(cin),
        .S(S),
        .carry(carry),
        .cout(cout)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("compressor42 Testbench");
        $display("========================================");


        
        
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
        input expected_S;
        input expected_carry;
        input expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: S=%b, carry=%b, cout=%b",
                         S, carry, cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%b, carry=%b, cout=%b",
                         expected_S, expected_carry, expected_cout);
                $display("  Got:      S=%b, carry=%b, cout=%b",
                         S, carry, cout);
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
