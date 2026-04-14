`timescale 1ns/1ps

module zzpenc64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    wire [5:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zzpenc64 dut (
        .a(a),
        .z(z)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 64'h0;
        $display("Test %0d: No bits set (Input: 0)", test_num);
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 64'h1;
        $display("Test %0d: LSB only (Input: bit 0)", test_num);
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 64'h8000_0000_0000_0000;
        $display("Test %0d: MSB only (Input: bit 63)", test_num);
        #1;

        check_outputs(6'd63);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 64'h2;
        $display("Test %0d: Bit 1 only", test_num);
        #1;

        check_outputs(6'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 64'h0000_0000_0000_0003;
        $display("Test %0d: Bits 0 and 1 set, expect 0", test_num);
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 64'h0000_0001_0000_0000;
        $display("Test %0d: Bit 32 only", test_num);
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 64'hE000_0000_0000_0000;
        $display("Test %0d: Bits 61, 62, 63 set, expect 61", test_num);
        #1;

        check_outputs(6'd61);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        $display("Test %0d: All bits set, expect 0", test_num);
        #1;

        check_outputs(6'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zzpenc64 Testbench");
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
        input [5:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
