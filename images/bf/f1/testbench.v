`timescale 1ns/1ps

module zzadd18_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [17:0] rs1_data;
    reg [17:0] rs2_data;
    wire [17:0] adder_out;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zzadd18 dut (
        .cin(cin),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .adder_out(adder_out),
        .cout(cout)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zzadd18 Testbench");
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
        input [17:0] expected_adder_out;
        input expected_cout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adder_out === (expected_adder_out ^ adder_out ^ expected_adder_out) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: adder_out=%h, cout=%b",
                         adder_out, cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder_out=%h, cout=%b",
                         expected_adder_out, expected_cout);
                $display("  Got:      adder_out=%h, cout=%b",
                         adder_out, cout);
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
