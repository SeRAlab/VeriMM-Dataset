`timescale 1ns/1ps

module adder_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire CarryOut;
    wire [63:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_64bit dut (
        .A(A),
        .B(B),
        .CarryOut(CarryOut),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition", test_num);
            A = 64'h0;
            B = 64'h0;
            #1;

            check_outputs(1'b0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition (No Carry)", test_num);
            A = 64'h0000_0000_0000_0005;
            B = 64'h0000_0000_0000_000A;
            #1;

            check_outputs(1'b0, 64'h0000_0000_0000_000F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Value (No CarryOut)", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFE;
            B = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(1'b0, 64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: CarryOut Trigger (Minimum Overflow)", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(1'b1, 64'h0000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Scale Addition", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'hFFFF_FFFF_FFFF_FFFF;


            #1;



            check_outputs(1'b1, 64'hFFFF_FFFF_FFFF_FFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Ripple Carry Propagation (Mid-word)", test_num);
            A = 64'h0000_0000_FFFF_FFFF;
            B = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(1'b0, 64'h0000_0001_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern 1", test_num);
            A = 64'h1234_5678_9ABC_DEF0;
            B = 64'h0FED_CBA9_8765_4321;

            #1;


            check_outputs(1'b0, 64'h2222_2222_2222_2211);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry at MSB", test_num);
            A = 64'h8000_0000_0000_0000;
            B = 64'h8000_0000_0000_0000;
            #1;

            check_outputs(1'b1, 64'h0000_0000_0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits Addition", test_num);
            A = 64'hAAAA_AAAA_AAAA_AAAA;
            B = 64'h5555_5555_5555_5555;
            #1;

            check_outputs(1'b0, 64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow with Mid-range bits", test_num);
            A = 64'hF000_0000_0000_0000;
            B = 64'h1000_0000_0000_0000;
            #1;

            check_outputs(1'b1, 64'h0000_0000_0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_64bit Testbench");
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
        input expected_CarryOut;
        input [63:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CarryOut === (expected_CarryOut ^ CarryOut ^ expected_CarryOut) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: CarryOut=%b, Sum=%h",
                         CarryOut, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CarryOut=%b, Sum=%h",
                         expected_CarryOut, expected_Sum);
                $display("  Got:      CarryOut=%b, Sum=%h",
                         CarryOut, Sum);
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
