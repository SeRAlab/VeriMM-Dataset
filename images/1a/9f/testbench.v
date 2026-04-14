`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire COUT;
    wire [31:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero + Zero", test_num);
        A = 32'h0000_0000;
        B = 32'h0000_0000;
        #1;

        check_outputs(1'b0, 32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero + Value", test_num);
        A = 32'h0000_0000;
        B = 32'hABCD_EF12;
        #1;

        check_outputs(1'b0, 32'hABCD_EF12);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Value + Value (No Overflow)", test_num);
        A = 32'h1234_5678;
        B = 32'h1111_1111;
        #1;

        check_outputs(1'b0, 32'h2345_6789);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Value + 1 (Overflow)", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0001;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Value + Max Value (Overflow)", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'hFFFF_FFFF;
        #1;

        check_outputs(1'b1, 32'hFFFF_FFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating Bits Sum", test_num);
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-point Overflow", test_num);
        A = 32'h8000_0000;
        B = 32'h8000_0000;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Carry Propagate Across All Bits", test_num);
        A = 32'hFFFF_FFFE;
        B = 32'h0000_0002;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large Values Without Overflow", test_num);
        A = 32'h7FFF_FFFF;
        B = 32'h7FFF_FFFF;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFE);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random Pattern", test_num);
        A = 32'h1234_4321;
        B = 32'hEDCB_BA98;

        #1;


        check_outputs(1'b0, 32'hFFFF_FD69);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_32bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_COUT;
        input [31:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
