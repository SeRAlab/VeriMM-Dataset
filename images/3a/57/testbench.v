`timescale 1ns/1ps

module adder32_tb;

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
    adder32 dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            A = 32'h0000_0000;
            B = 32'h0000_0000;
            #1;

            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic addition without carry-out", test_num);
            A = 32'h0000_1234;
            B = 32'h0000_4321;
            #1;

            check_outputs(1'b0, 32'h0000_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max value without carry-out", test_num);
            A = 32'hFFFF_FFFE;
            B = 32'h0000_0001;
            #1;

            check_outputs(1'b0, 32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition resulting in overflow (carry-out)", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both inputs max value", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'hFFFF_FFFF;
            #1;

            check_outputs(1'b1, 32'hFFFF_FFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (0x5 and 0xA)", test_num);
            A = 32'h5555_5555;
            B = 32'hAAAA_AAAA;
            #1;

            check_outputs(1'b0, 32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry propagation from LSB to MSB", test_num);
            A = 32'h7FFF_FFFF;
            B = 32'h0000_0001;
            #1;

            check_outputs(1'b0, 32'h8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large numbers with carry-out", test_num);
            A = 32'h8000_0000;
            B = 32'h8000_0000;
            #1;

            check_outputs(1'b1, 32'h0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random data pattern 1", test_num);
            A = 32'h1234_5678;
            B = 32'h8765_4321;
            #1;

            check_outputs(1'b0, 32'h9999_9999);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random data pattern 2 with carry", test_num);
            A = 32'hF0F0_F0F0;
            B = 32'h1010_1010;
            #1;

            check_outputs(1'b1, 32'h0101_0100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder32 Testbench");
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
