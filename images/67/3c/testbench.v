`timescale 1ns/1ps

module adder_64bit_tb;

    // Testbench signals (combinational circuit)
    reg Cin;
    reg [63:0] a;
    reg [63:0] b;
    wire Co;
    wire [63:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_64bit dut (
        .Cin(Cin),
        .a(a),
        .b(b),
        .Co(Co),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Addition (No Carry)", test_num);
        a = 64'h0000_0000_0000_0005;
        b = 64'h0000_0000_0000_000A;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Addition with Carry-in", test_num);
        a = 64'h0000_0000_0000_0005;
        b = 64'h0000_0000_0000_000A;
        Cin = 1'b1;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_0010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry between 16-bit blocks", test_num);
        a = 64'h0000_0000_0000_FFFF;
        b = 64'h0000_0000_0000_0001;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0001_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 64-bit Overflow (Carry-out)", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'h0000_0000_0000_0001;
        Cin = 1'b0;
        #1;

        check_outputs(1'b1, 64'h0000_0000_0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Full Propagation (All 1s + Cin)", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'h0000_0000_0000_0000;
        Cin = 1'b1;
        #1;

        check_outputs(1'b1, 64'h0000_0000_0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Input Addition with Cin", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'hFFFF_FFFF_FFFF_FFFF;
        Cin = 1'b1;


        #1;



        check_outputs(1'b1, 64'hFFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Patterned Addition", test_num);
        a = 64'h5555_5555_5555_5555;
        b = 64'hAAAA_AAAA_AAAA_AAAA;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 64'hFFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Addition", test_num);
        a = 64'h0000_0000_0000_0000;
        b = 64'h0000_0000_0000_0000;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 64'h0000_0000_0000_0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Numbers No Overflow", test_num);
        a = 64'h1234_5678_9ABC_DEF0;
        b = 64'h1111_1111_1111_1111;
        Cin = 1'b0;
        #1;

        check_outputs(1'b0, 64'h2345_6789_ABDD_FFF1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multi-block Carry Propagation", test_num);
        a = 64'hFFFE_FFFF_FFFF_FFFF;
        b = 64'h0000_0000_0000_0001;
        Cin = 1'b1;
        #1;

        check_outputs(1'b0, 64'hFFFF_0000_0000_0001);
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
        input expected_Co;
        input [63:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Co === (expected_Co ^ Co ^ expected_Co) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: Co=%b, y=%h",
                         Co, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Co=%b, y=%h",
                         expected_Co, expected_y);
                $display("  Got:      Co=%b, y=%h",
                         Co, y);
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
