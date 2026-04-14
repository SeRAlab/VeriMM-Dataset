`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Multiplication (0 * 0)", test_num);
            a = 32'h0;
            b = 32'h0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication by Zero (0x12345678 * 0)", test_num);
            a = 32'h1234_5678;
            b = 32'h0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Multiplication (0xDEADBEEF * 1)", test_num);
            a = 32'hDEAD_BEEF;
            b = 32'h1;
            #1;

            check_outputs(64'h0000_0000_DEAD_BEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Numbers (123 * 456)", test_num);
            a = 32'd123;
            b = 32'd456;
            #1;

            check_outputs(64'd56088);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of Two (2^16 * 2^15)", test_num);
            a = 32'h0001_0000;
            b = 32'h0000_8000;
            #1;

            check_outputs(64'h0000_0000_8000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Input * 2", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h2;
            #1;

            check_outputs(64'h0000_0001_FFFF_FFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Product (0xAAAA_AAAA * 0x5555_5555)", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            #1;

            check_outputs(64'h38E3_8E38_71C7_1C72);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit Pattern (0x1234_5678 * 0x8765_4321)", test_num);
            a = 32'h1234_5678;
            b = 32'h8765_4321;
            #1;

            check_outputs(64'h09A1_0C04_2468_ACF8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum 32-bit Squaring (2^32-1)^2", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;

            #1;


            check_outputs(64'hFFFF_FFFE_0000_0001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range value (0x8000_0000 * 0x8000_0000)", test_num);
            a = 32'h8000_0000;
            b = 32'h8000_0000;
            #1;

            check_outputs(64'h4000_0000_0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier Testbench");
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
        input [63:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
