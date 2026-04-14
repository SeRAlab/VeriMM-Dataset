`timescale 1ns/1ps

module or_128bit_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] a;
    reg [127:0] b;
    wire [127:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    or_128bit dut (
        .a(a),
        .b(b),
        .y(y)
    );
    task testcase001;

    begin
        $display("Testcase 001: All Zeros");
        test_num = 1;
        a = 128'h0;
        b = 128'h0;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: All Ones (Operand A)");
        test_num = 2;
        a = {4{32'hFFFFFFFF}};
        b = 128'h0;
        #1;

        check_outputs({4{32'hFFFFFFFF}});
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: All Ones (Operand B)");
        test_num = 3;
        a = 128'h0;
        b = {4{32'hFFFFFFFF}};
        #1;

        check_outputs({4{32'hFFFFFFFF}});
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Checkerboard Patterns");
        test_num = 4;
        a = {4{32'hAAAAAAAA}};
        b = {4{32'h55555555}};
        #1;

        check_outputs({4{32'hFFFFFFFF}});
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: MSB and LSB Boundary");
        test_num = 5;
        a = 128'h1;
        b = 128'h80000000_00000000_00000000_00000000;
        #1;

        check_outputs(128'h80000000_00000000_00000000_00000001);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Random Patterns Across Blocks");
        test_num = 6;

        a = 128'hF0F0F0F0_0000FFFF_12345678_AAAAAAAA;
        b = 128'h0F0F0F0F_FFFF0000_87654321_55555555;




        #1;





        check_outputs(128'hFFFFFFFF_FFFFFFFF_97755779_FFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Sparse Bits");
        test_num = 7;
        a = 128'h00000001_00000000_00000000_00000000;
        b = 128'h00000000_00000000_00000000_00000001;
        #1;

        check_outputs(128'h00000001_00000000_00000000_00000001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("or_128bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [127:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
