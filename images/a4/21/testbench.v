`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg add32;
    reg [31:0] b;
    reg cin;
    wire [31:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .add32(add32),
        .b(b),
        .cin(cin),
        .z(z)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 32'h0000_0005;
        b = 32'h0000_000A;
        cin = 1'b0;
        add32 = 1'b1;
        #1;

        check_outputs(32'h0000_000F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 32'h0000_FFFF;
        b = 32'h0000_0001;
        cin = 1'b0;
        add32 = 1'b1;
        #1;

        check_outputs(32'h0001_0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 32'h0000_FFFF;
        b = 32'h0000_0001;
        cin = 1'b0;
        add32 = 1'b0;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 32'h1234_5678;
        b = 32'h1111_1111;
        cin = 1'b1;
        add32 = 1'b1;
        #1;

        check_outputs(32'h1234_5678 + 32'h1111_1111 + 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 32'hFFFF_7FFF;
        b = 32'h0000_8001;
        cin = 1'b0;
        add32 = 1'b1;


        #1;



        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 32'hFFFF_7FFF;
        b = 32'h0000_8001;
        cin = 1'b0;
        add32 = 1'b0;


        #1;



        check_outputs(32'hFFFF_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 32'hA5A5_FFFF;
        b = 32'h0000_0000;
        cin = 1'b1;
        add32 = 1'b1;
        #1;

        check_outputs(32'hA5A6_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 32'h1111_FFFF;
        b = 32'h0000_0000;
        cin = 1'b1;
        add32 = 1'b0;


        #1;



        check_outputs(32'h1111_0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 32'h1234_0000;
        b = 32'h4321_0000;
        cin = 1'b0;
        add32 = 1'b1;
        #1;

        check_outputs(32'h5555_0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 32'hFFFF_FFFF;
        b = 32'hFFFF_FFFF;
        cin = 1'b1;
        add32 = 1'b1;


        #1;



        check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_z;
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
