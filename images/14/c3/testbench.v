`timescale 1ns/1ps

module multiplier_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [127:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_64bit dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero multiplication");
            test_num = test_num + 1;
            a = 64'd0;
            b = 64'hFFFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(128'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Identity multiplication");
            test_num = test_num + 1;
            a = 64'hA5A5_A5A5_A5A5_A5A5;
            b = 64'd1;
            #1;

            check_outputs({64'd0, 64'hA5A5_A5A5_A5A5_A5A5});
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simple small values");
            test_num = test_num + 1;
            a = 64'd12345;
            b = 64'd67890;

            #1;


            check_outputs(128'h31F1C622);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Maximum values (All Fs)");
            test_num = test_num + 1;
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'hFFFF_FFFF_FFFF_FFFF;

            #1;


            check_outputs(128'hFFFF_FFFF_FFFF_FFFE_0000_0000_0000_0001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Power of 2 (Shift check)");
            test_num = test_num + 1;
            a = 64'h0000_0000_0000_0001;
            b = 64'h8000_0000_0000_0000;
            #1;

            check_outputs(128'h0000_0000_0000_0000_8000_0000_0000_0000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Overflow into upper 64 bits");
            test_num = test_num + 1;
            a = 64'h8000_0000_0000_0000;
            b = 64'h0000_0000_0000_0002;

            #1;


            check_outputs(128'h0000_0000_0000_0001_0000_0000_0000_0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Arbitrary large values");
            test_num = test_num + 1;
            a = 64'h1234_5678_9ABC_DEF0;
            b = 64'h0FED_CBA9_8765_4321;


            #1;



            check_outputs(128'h0121_9AB0_C765_00F3_5806_49D3_A9A6_46F0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Alternating bit patterns");
            test_num = test_num + 1;
            a = 64'hAAAA_AAAA_AAAA_AAAA;
            b = 64'h5555_5555_5555_5555;

            #1;


            check_outputs(128'h38E3_8E38_E38E_38E3_1C71_C71C_71C7_1C72);
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
        testcase007();
        testcase008();
        
        
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
        input [127:0] expected_result;
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
