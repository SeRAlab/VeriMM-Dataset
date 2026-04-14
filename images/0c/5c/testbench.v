`timescale 1ns/1ps

module multiplier_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire [127:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_64bit dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Inputs", test_num);
            A = 64'h0;
            B = 64'h0;
            #1;

            check_outputs(128'h0);

            test_num = test_num + 1;
            $display("Test %0d: Zero Multiplicand", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity (1 * B)", test_num);
            A = 64'h1;
            B = 64'hABCD_EF01_2345_6789;
            #1;

            check_outputs(128'h0000_0000_0000_0000_ABCD_EF01_2345_6789);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small Integers (12345 * 67890)", test_num);
            A = 64'd12345;
            B = 64'd67890;

            #1;


            check_outputs(128'h0000_0000_0000_0000_0000_0000_31F2_9022);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Powers of 2 (2^32 * 2^32 = 2^64)", test_num);
            A = 64'h0000_0001_0000_0000;
            B = 64'h0000_0001_0000_0000;
            #1;

            check_outputs(128'h0000_0000_0000_0001_0000_0000_0000_0000);

            test_num = test_num + 1;
            $display("Test %0d: Upper bit test (2^63 * 2)", test_num);
            A = 64'h8000_0000_0000_0000;
            B = 64'h2;
            #1;

            check_outputs(128'h0000_0000_0000_0001_0000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Arbitrary Values", test_num);
            A = 64'hFEDC_BA98_7654_3210;
            B = 64'h0123_4567_89AB_CDEF;

            #1;


            check_outputs(128'h01210DD50D0643799632D197C7C33210);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Unsigned Product (2^64-1)^2", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'hFFFF_FFFF_FFFF_FFFF;


            #1;



            check_outputs(128'hFFFF_FFFF_FFFF_FFFE_0000_0000_0000_0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_64bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [127:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
