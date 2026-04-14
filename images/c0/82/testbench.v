`timescale 1ns/1ps

module daa_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] flags;
    reg [7:0] val;
    wire [7:0] adjust;
    wire cdaa;
    wire hdaa;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    daa dut (
        .flags(flags),
        .val(val),
        .adjust(adjust),
        .cdaa(cdaa),
        .hdaa(hdaa)
    );
    task testcase001;

        begin
            test_num = 1;
            flags = 8'h00;
            val = 8'h12;
            $display("Test %0d: Addition, no adjustment (val=0x%h, flags=0x%h)", test_num, val, flags);
            #1;

            check_outputs(8'h12, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            flags = 8'h00;
            val = 8'h0B;
            $display("Test %0d: Addition, lower nibble > 9 (val=0x%h, flags=0x%h)", test_num, val, flags);
            #1;

            check_outputs(8'h11, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            flags = 8'h10;
            val = 8'h12;
            $display("Test %0d: Addition, H flag set (val=0x%h, flags=0x%h)", test_num, val, flags);
            #1;

            check_outputs(8'h18, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            flags = 8'h00;
            val = 8'hA2;
            $display("Test %0d: Addition, upper nibble > 9 (val=0x%h, flags=0x%h)", test_num, val, flags);
            #1;

            check_outputs(8'h02, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            flags = 8'h01;
            val = 8'h12;
            $display("Test %0d: Addition, C flag set (val=0x%h, flags=0x%h)", test_num, val, flags);
            #1;

            check_outputs(8'h72, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            flags = 8'h02;
            val = 8'h42;
            $display("Test %0d: Subtraction, no adjustment (val=0x%h, flags=0x%h)", test_num, val, flags);
            #1;

            check_outputs(8'h42, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            flags = 8'h12;
            val = 8'h12;
            $display("Test %0d: Subtraction, H flag set (val=0x%h, flags=0x%h)", test_num, val, flags);
            #1;

            check_outputs(8'h0C, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            flags = 8'h03;
            val = 8'h82;
            $display("Test %0d: Subtraction, C flag set (val=0x%h, flags=0x%h)", test_num, val, flags);
            #1;

            check_outputs(8'h22, 1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            flags = 8'h00;
            val = 8'h9B;
            $display("Test %0d: Addition, both nibbles > 9 (val=0x%h, flags=0x%h)", test_num, val, flags);
            #1;

            check_outputs(8'h01, 1'b1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            flags = 8'h13;
            val = 8'h32;
            $display("Test %0d: Subtraction, both C and H flags set (val=0x%h, flags=0x%h)", test_num, val, flags);
            #1;

            check_outputs(8'hCC, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("daa Testbench");
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
        input [7:0] expected_adjust;
        input expected_cdaa;
        input expected_hdaa;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adjust === (expected_adjust ^ adjust ^ expected_adjust) &&
                expected_cdaa === (expected_cdaa ^ cdaa ^ expected_cdaa) &&
                expected_hdaa === (expected_hdaa ^ hdaa ^ expected_hdaa)) begin
                $display("PASS");
                $display("  Outputs: adjust=%h, cdaa=%b, hdaa=%b",
                         adjust, cdaa, hdaa);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adjust=%h, cdaa=%b, hdaa=%b",
                         expected_adjust, expected_cdaa, expected_hdaa);
                $display("  Got:      adjust=%h, cdaa=%b, hdaa=%b",
                         adjust, cdaa, hdaa);
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
