`timescale 1ns/1ps

module Compare_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire EQ;
    wire GEZ;
    wire GZ;
    wire LEZ;
    wire LZ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Compare dut (
        .A(A),
        .B(B),
        .EQ(EQ),
        .GEZ(GEZ),
        .GZ(GZ),
        .LEZ(LEZ),
        .LZ(LZ)
    );
    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Compare Testbench");
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
        input expected_EQ;
        input expected_GEZ;
        input expected_GZ;
        input expected_LEZ;
        input expected_LZ;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_GEZ === (expected_GEZ ^ GEZ ^ expected_GEZ) &&
                expected_GZ === (expected_GZ ^ GZ ^ expected_GZ) &&
                expected_LEZ === (expected_LEZ ^ LEZ ^ expected_LEZ) &&
                expected_LZ === (expected_LZ ^ LZ ^ expected_LZ)) begin
                $display("PASS");
                $display("  Outputs: EQ=%b, GEZ=%b, GZ=%b, LEZ=%b, LZ=%b",
                         EQ, GEZ, GZ, LEZ, LZ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%b, GEZ=%b, GZ=%b, LEZ=%b, LZ=%b",
                         expected_EQ, expected_GEZ, expected_GZ, expected_LEZ, expected_LZ);
                $display("  Got:      EQ=%b, GEZ=%b, GZ=%b, LEZ=%b, LZ=%b",
                         EQ, GEZ, GZ, LEZ, LZ);
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
