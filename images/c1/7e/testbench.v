`timescale 1ns/1ps

module zznor64_32_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    wire znor32;
    wire znor64;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zznor64_32 dut (
        .a(a),
        .znor32(znor32),
        .znor64(znor64)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: All zeros", test_num);
        a = 64'h0000_0000_0000_0000;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Upper 32 bits non-zero", test_num);
        a = 64'hFFFF_FFFF_0000_0000;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Lower 32 bits non-zero", test_num);
        a = 64'h0000_0000_FFFF_FFFF;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: All bits are one", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: Bit 0 is one", test_num);
        a = 64'h0000_0000_0000_0001;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %03d: Bit 31 is one", test_num);
        a = 64'h0000_0000_8000_0000;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %03d: Bit 32 is one", test_num);
        a = 64'h0000_0001_0000_0000;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %03d: Bit 63 is one", test_num);
        a = 64'h8000_0000_0000_0000;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %03d: Bit 40 is one, others zero", test_num);
        a = (64'h1 << 40);
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %03d: Mixed pattern", test_num);
        a = 64'hA5A5_A5A5_0000_8000;
        #1;

        check_outputs(0, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zznor64_32 Testbench");
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
        input expected_znor32;
        input expected_znor64;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_znor32 === (expected_znor32 ^ znor32 ^ expected_znor32) &&
                expected_znor64 === (expected_znor64 ^ znor64 ^ expected_znor64)) begin
                $display("PASS");
                $display("  Outputs: znor32=%b, znor64=%b",
                         znor32, znor64);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: znor32=%b, znor64=%b",
                         expected_znor32, expected_znor64);
                $display("  Got:      znor32=%b, znor64=%b",
                         znor32, znor64);
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
