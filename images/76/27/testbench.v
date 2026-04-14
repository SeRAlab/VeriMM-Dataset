`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 64'h0;
        b = 64'h0;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 64'd123456789;
        b = 64'd987654321;
        #1;

        check_outputs(64'd1111111110);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 64'h7000_0000_0000_0000;
        b = 64'h0FFF_FFFF_FFFF_FFFF;
        #1;

        check_outputs(64'h7FFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'h0000_0000_0000_0001;
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 64'hAAAA_AAAA_AAAA_AAAA;
        b = 64'h5555_5555_5555_5555;
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 64'hFFFF_FFFF_FFFF_FFFE;
        b = 64'h0000_0000_0000_0002;
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'hFFFF_FFFF_FFFF_FFFF;
        #1;

        check_outputs(64'hFFFF_FFFF_FFFF_FFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 64'h8000_0000_0000_0000;
        b = 64'h8000_0000_0000_0000;
        #1;

        check_outputs(64'h0000_0000_0000_0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [63:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
