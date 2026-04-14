`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] forwardA;
    reg [4:0] forwardB;
    reg [31:0] regA_value;
    reg [31:0] regB_value;
    reg [4:0] src1;
    reg [4:0] src2;
    wire [31:0] resultA;
    wire [31:0] resultB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .forwardA(forwardA),
        .forwardB(forwardB),
        .regA_value(regA_value),
        .regB_value(regB_value),
        .src1(src1),
        .src2(src2),
        .resultA(resultA),
        .resultB(resultB)
    );
    task testcase001;

    begin
        test_num = 1;
        src1 = 5'd10;
        src2 = 5'd20;
        forwardA = 5'd10;
        forwardB = 5'd20;
        regA_value = 32'hAAAA_AAAA;
        regB_value = 32'hBBBB_BBBB;
        #1;

        check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        src1 = 5'd15;
        src2 = 5'd25;
        forwardA = 5'd25;
        forwardB = 5'd15;
        regA_value = 32'h1111_2222;
        regB_value = 32'h3333_4444;
        #1;

        check_outputs(32'h3333_4444, 32'h1111_2222);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        src1 = 5'd5;
        src2 = 5'd6;
        forwardA = 5'd1;
        forwardB = 5'd2;
        regA_value = 32'hDEAD_BEEF;
        regB_value = 32'hC0DE_FEED;
        #1;

        check_outputs(32'h0000_0000, 32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        src1 = 5'd8;
        src2 = 5'd0;
        forwardA = 5'd8;
        forwardB = 5'd8;
        regA_value = 32'hAAAA_1111;
        regB_value = 32'hBBBB_2222;
        #1;

        check_outputs(32'hAAAA_1111, 32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        src1 = 5'd0;
        src2 = 5'd0;
        forwardA = 5'd0;
        forwardB = 5'd0;
        regA_value = 32'hFFFF_FFFF;
        regB_value = 32'hFFFF_FFFF;
        #1;

        check_outputs(32'h0000_0000, 32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        src1 = 5'd12;
        src2 = 5'd12;
        forwardA = 5'd12;
        forwardB = 5'd0;
        regA_value = 32'h55AA_55AA;
        regB_value = 32'h0000_0000;
        #1;

        check_outputs(32'h55AA_55AA, 32'h55AA_55AA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        src1 = 5'd4;
        src2 = 5'd9;
        forwardA = 5'd0;
        forwardB = 5'd4;
        regA_value = 32'h0000_0000;
        regB_value = 32'h9999_8888;
        #1;

        check_outputs(32'h9999_8888, 32'h0000_0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input [31:0] expected_resultA;
        input [31:0] expected_resultB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resultA === (expected_resultA ^ resultA ^ expected_resultA) &&
                expected_resultB === (expected_resultB ^ resultB ^ expected_resultB)) begin
                $display("PASS");
                $display("  Outputs: resultA=%h, resultB=%h",
                         resultA, resultB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resultA=%h, resultB=%h",
                         expected_resultA, expected_resultB);
                $display("  Got:      resultA=%h, resultB=%h",
                         resultA, resultB);
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
