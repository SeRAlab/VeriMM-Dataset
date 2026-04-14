`timescale 1ns/1ps

module my_oddrx8_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] d0;
    reg [7:0] d1;
    wire [7:0] io;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    my_oddrx8 dut (
        .clk(clk),
        .d0(d0),
        .d1(d1),
        .io(io)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("my_oddrx8 Testbench");
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
        input [7:0] expected_io;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io === (expected_io ^ io ^ expected_io)) begin
                $display("PASS");
                $display("  Outputs: io=%h",
                         io);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io=%h",
                         expected_io);
                $display("  Got:      io=%h",
                         io);
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
